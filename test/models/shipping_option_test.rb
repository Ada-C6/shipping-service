require 'test_helper'

class ShippingOptionTest < ActiveSupport::TestCase
  setup do
    @package = ShippingOption.create_package(10)
    @origin = ShippingOption.location('98101')
    @destination = ShippingOption.location('01003')
  end

  test "ShippingOption must have a name and cost greater than 0" do
    positive_case = shipping_options(:one)
    negative_case = shipping_options(:two)

    assert positive_case.valid?
    assert_not negative_case.valid?
  end

  test "Self.search should return an array of ShippingOption objects" do
    VCR.use_cassette("shipments") do
        package = 10
        destination = '98107'
        origin = '98101'

      options = ShippingOption.search(origin, destination, package)

      assert_kind_of Array, options

      options.each do |item|
        assert_kind_of ShippingOption, item
      end
    end

  end

  test "Self.create_package: we can create a package given a positive weight" do
    weight = 10 #in pounds
    package = ShippingOption.create_package(weight)

    assert_instance_of ActiveShipping::Package, package
  end

  test "Self.create_package: we return an error if package_weight is below zero" do
    assert_raises ArgumentError do
      weight = -10 #in pounds
      ShippingOption.create_package(weight)
    end
  end

  test "Self.create_package: we return an error if package_weight is zero" do
    assert_raises ArgumentError do
      weight = 0 #in pounds
      ShippingOption.create_package(weight)
    end
  end

  test "Self.location will create a valid location" do
      zip_code = "98109"
      location = ShippingOption.location(zip_code)

      assert_instance_of ActiveShipping::Location, location
  end

  test "Self.location will not be able to create a location without a valid postal code and country and will raise an error" do
    assert_raises ArgumentError do
      zip_code = ""
      ShippingOption.location(zip_code)
    end
  end

  test "Self.get_rates_from_provider will take in a provider and return an array of arrays containing service name and price" do
    VCR.use_cassette("shipments") do
      provider = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])

      response = ShippingOption.get_rates_from_provider(provider, @origin, @destination, @package)

      assert_kind_of Array, response

      response.each do |array|
        assert array[0].include? 'USPS'
        assert_operator 0,:<=, array[1].to_i
      end
    end
  end

  test "Self.get_rates_from_provider will take in a ups and return an array of arrays containing service name and price" do
    VCR.use_cassette("shipments") do
      provider = ActiveShipping::UPS.new(login: ENV['ACTIVESHIPPING_UPS_LOGIN'], password: ENV['ACTIVESHIPPING_UPS_PASSWORD'],key: ENV['ACTIVESHIPPING_UPS_KEY'] )

      response = ShippingOption.get_rates_from_provider(provider, @origin, @destination, @package)

      assert_kind_of Array, response

      response.each do |array|
        assert array[0].include? 'UPS'
        assert_operator 0,:<=, array[1].to_i
      end
    end
  end

  test "Self.get_rates_from_provider returns an error if provider is not a supported ActiveShipping provider" do
    VCR.use_cassette("shipments") do
      assert_raises ArgumentError do
        provider = "fedex"
        ShippingOption.get_rates_from_provider(provider, @origin, @destination, @package)
      end
    end
  end

  test "Self.ups successfully makes an ActiveShipping::UPS" do
    VCR.use_cassette("shipments") do
      ups = ShippingOption.ups
      assert_instance_of ActiveShipping::UPS, ups
    end
  end

  test "Self.usps successfully makes an ActiveShipping::USPS" do
    VCR.use_cassette("shipments") do
      usps = ShippingOption.usps
      assert_instance_of ActiveShipping::USPS, usps
    end
  end



end

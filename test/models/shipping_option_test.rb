require 'test_helper'

class ShippingOptionTest < ActiveSupport::TestCase
  test "ShippingOption must have a name and cost greater than 0" do
    positive_case = shipping_options(:one)
    negative_case = shipping_options(:two)

    assert positive_case.valid?
    assert_not negative_case.valid?
  end

  test "Self.package: we can create a package given a positive weight" do
    weight = 10 #in pounds
    package = ShippingOption.package(weight)

    assert_instance_of ActiveShipping::Package, package
  end

  test "Self.package: we return an error if package_weight is below zero" do
    assert_raises ArgumentError do
      weight = -10 #in pounds
      package = ShippingOption.package(weight)
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
      location = ShippingOption.location(zip_code)
    end
  end
end

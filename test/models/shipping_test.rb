require 'test_helper'

class ShippingTest < ActiveSupport::TestCase
  fixtures :all
  # test "the truth" do
  #   assert true
  # end

  test "should create a destination" do
    shipment = Shipping.new
    city = shippings(:destination_one).city
    state = shippings(:destination_one).state
    zip = shippings(:destination_one).zip
    country = shippings(:destination_one).country
    # address = country: '#{country}', state: '#{state}', city: '#{city}', zip: '#{zip}'"
    location = shipment.destination(country, state, city, zip)
    assert_not_nil location
    assert_kind_of ActiveShipping::Location, location
  end

  test "self.ups: find the rates for a package using ups as the carrier" do
    city = shippings(:destination_one).city
    state = shippings(:destination_one).state
    zip = shippings(:destination_one).zip
    country = shippings(:destination_one).country
    shipment = Shipping.new
    origin = ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98122')

    destination = shipment.destination(country, state, city, zip)
    #
     weights_string = shippings(:weights_two).weights
    #
    packages =   shipment.create_packages(weights_string)
    #

    #shipment is the item
    shipment_results =   shipment.ups(origin, destination, packages)
    assert_not_nil shipment_results
    assert_kind_of Array, shipment_results
    assert_kind_of Array, shipment_results[0]
    assert_equal shipment_results.count, 6
    # puts shipment


  end

  test "should return array of packages" do
    shipment = Shipping.new
    weights_string = shippings(:weights_one).weights
    packages = shipment.create_packages(weights_string)
    assert_not_nil packages
    assert_kind_of Array, packages
    assert_equal packages.count, 5
  end

  test "usps method should return array of arrays with service name and cost" do
    ORIGIN = ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98122')
    origin = ORIGIN
    shipment = Shipping.new

    city = shippings(:destination_two).city
    state = shippings(:destination_two).state
    zip = shippings(:destination_two).zip
    country = shippings(:destination_two).country
    destination = shipment.destination(country, state, city, zip)

    weights_string = shippings(:weights_two).weights
    packages = shipment.create_packages(weights_string)

    rates = shipment.usps(origin, destination, packages)
    assert_not_nil rates
    assert_kind_of Array, rates
    assert_kind_of Array, rates[0]
    assert_equal rates.count, 5
    # puts rates
  end


end

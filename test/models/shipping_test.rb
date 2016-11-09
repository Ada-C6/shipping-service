require 'test_helper'

class ShippingTest < ActiveSupport::TestCase
  fixtures :all
  # test "the truth" do
  #   assert true
  # end

  test "should create a destination" do
    city = shippings(:destination_one).city
    state = shippings(:destination_one).state
    zip = shippings(:destination_one).zip
    country = shippings(:destination_one).country
    # address = country: '#{country}', state: '#{state}', city: '#{city}', zip: '#{zip}'"
    location = Shipping.destination(country, state, city, zip)
    assert_not_nil location
    assert_kind_of ActiveShipping::Location, location
  end

  test "should return array of packages" do
    weights_string = shippings(:weights_one).weights
    packages = Shipping.create_packages(weights_string)
    assert_not_nil packages
    assert_kind_of Array, packages
    assert_equal packages.count, 5
  end

  test "usps method should return array of arrays with service name and cost" do
    ORIGIN = ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98122')
    origin = ORIGIN

    city = shippings(:destination_two).city
    state = shippings(:destination_two).state
    zip = shippings(:destination_two).zip
    country = shippings(:destination_two).country
    destination = Shipping.destination(country, state, city, zip)

    weights_string = shippings(:weights_two).weights
    packages = Shipping.create_packages(weights_string)

    rates = Shipping.usps(origin, destination, packages)
    assert_not_nil rates
    assert_kind_of Array, rates
    assert_kind_of Array, rates[0]
    assert_equal rates.count, 6
    puts rates
  end

end

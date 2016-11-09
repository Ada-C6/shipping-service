require 'test_helper'

class ShippingTest < ActiveSupport::TestCase
  fixtures :all
  # test "the truth" do
  #   assert true
  # end

  test "should create a destination" do
    city = shippings(:one).city
    state = shippings(:one).state
    zip = shippings(:one).zip
    country = shippings(:one).country
    # address = country: '#{country}', state: '#{state}', city: '#{city}', zip: '#{zip}'"
    location = Shipping.destination(country, state, city, zip)
    assert_not_nil location
  end












  test "find the rates for a package using ups as the carrier" do
    city = shippings(:one).city
    state = shippings(:one).state
    zip = shippings(:one).zip
    country = shippings(:one).country

    origin = ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98122')

    packages
    destination = Shipping.destination(country, state, city, zip)
  end
end

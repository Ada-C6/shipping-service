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

  test "should return array of packages" do
    weights_string = shippings(:weights_one).weights
    packages = Shipping.create_packages(weights_string)
    assert_not_nil packages
    assert_kind_of Array, packages
    assert_equal packages.count, 5
  end
end

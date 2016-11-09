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
end

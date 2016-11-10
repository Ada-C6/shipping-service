require 'test_helper'

class ShippingRateTest < ActiveSupport::TestCase
  test "should be able to create a new ShippingRate with name and cost" do
    quote = ShippingRate.new(name: "Heather's Great Shipping", cost: 12345)

    assert quote.save
    assert_equal quote.name, "Heather's Great Shipping"
    assert_equal quote.cost, 12345
  end

  test "should not be able to add random attributes to a new ShippingRate object" do
    assert_raises ActiveRecord::UnknownAttributeError do
      quote = ShippingRate.new(hat: "Fedora")
      assert_not quote.valid?
    end
  end

  # @todo - validate model?

  test "get_rates should return an array of ShippingRate objects when passed a hash with correct parameters" do
    shipment = { weight: 10,
      origin_country: "US",
      origin_state: "WA",
      origin_city: "Seattle",
      origin_zip: "98122",
      destination_country: "US",
      destination_state: "NY",
      destination_city: "Brooklyn",
      destination_zip: "11206",
    }

    rates = ShippingRate.get_rates(shipment)

    assert_instance_of Array, rates
    assert_not_empty rates

    rates.each do |rate|
      assert_instance_of ShippingRate, rate
    end
  end

  test "get_rates should return an appropriate response when zip code and state don't match" do
    shipment = { weight: 10,
      origin_country: "US",
      origin_state: "WA",
      origin_city: "Seattle",
      origin_zip: "98122",
      destination_country: "US",
      destination_state: "NY",
      destination_city: "Brooklyn",
      destination_zip: "98101" }

    assert_raises ActiveShipping::ResponseError do
      ShippingRate.get_rates(shipment)
      assert_match /Failure/, ActiveShipping::ResponseError.response
    end
  end
end

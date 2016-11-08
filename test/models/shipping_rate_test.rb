require 'test_helper'

class ShippingRateTest < ActiveSupport::TestCase
  test "should be able to create a new ShippingRate with name and cost" do
    quote = ShippingRate.new(name: "Heather's Great Shipping", cost: 12345)

    assert quote.save
    assert_equal quote.name, "Heather's Great Shipping"
    assert_equal quote.cost, 12345
  end

  # @todo - test the negative on create
  # @todo - validate model?

  test "get_rates should return an array of ShippingRate objects when passed an array of hashes with correct parameters" do
    # @todo - state that shipment is coming from a single package always
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





  # test "get_rate method should return an arra" do
  #
  # end

  # test "" do
  #
  # end
  #
  # test "" do
  #
  # end
  #
  # test "" do
  #
  # end
  #
  # test "" do
  #
  # end
  #
  # test "" do
  #
  # end
  #

end

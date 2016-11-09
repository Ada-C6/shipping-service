require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "#get_destination must create ActiveShipping::Location object" do
    ship = shipments(:one)
    dest = ship.get_destination
    assert_kind_of ActiveShipping::Location, dest

    assert_equal "Pasadena", dest.city

  end

  test "self.origin must create ActiveShipping::Location object" do
    ship = shipments(:one)
    origin = ship.get_origin
    assert_kind_of ActiveShipping::Location, origin
    assert_equal "Seattle", origin.city
  end

  test "#get_package must create ActiveShipping::Package object" do
    ship = shipments(:one)
    pack = ship.get_package
    assert_kind_of ActiveShipping::Package, pack
    assert_equal pack.weight, 15
  end

  test "#ups_rates should return an array of arrays of service name and rates" do
    ship = Shipment.new(city: "Seattle", zip: "98108", weight: 10)
    rates = ship.ups_rates
    assert_kind_of Array, rates
    assert_kind_of Array, rates[0]
  end

  test "#usps_rates should return an array of arrays of service name and rates" do
    ship = Shipment.new(city: "Seattle", zip: "98108", weight: 10)
    rates = ship.usps_rates
    assert_kind_of Array, rates
    assert_kind_of Array, rates[0]
  end

  test "#all_rates should return and array of arrays whose length is the sum of both carrier rates" do
    ship = Shipment.new(city: "Seattle", zip: "98108", weight: 10)
    usps_rates = ship.usps_rates
    ups_rates = ship.ups_rates
    all_rates = ship.all_rates

    assert_equal all_rates.length, (usps_rates + ups_rates).length
  end

  test "#generate_quotes should create Quote instances" do
    ship = Shipment.new(city: "Seattle", zip: "98108", weight: 10)
    quotes = ship.generate_quotes
    quotes.each do |quote|
      assert_kind_of Quote, quote
    end
  end
end

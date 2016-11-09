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

end

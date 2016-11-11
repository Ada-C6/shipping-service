require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  PACKAGE_INFO = {
    weight: 3.5,
    length: 15,
    width: 10,
    height: 4.5
  }

  DESTINATION_HASH = {
    country: "US",
    state: "CA",
    city: "Los Angeles",
    postal_code: "90078"
  }

  ORIGIN_HASH = {
    country: "US",
    state: "WA",
    city: "Seattle",
    postal_code: "98125"
  }

  test "the truth" do
    assert true
  end

  test "self.package creates a package object" do
    test_package = Shipment.package(3.5, 15, 10, 4.5)
    assert_instance_of ActiveShipping::Package, test_package

    assert_equal PACKAGE_INFO[:weight], test_package.pounds
    assert_equal [4.5,10,15], test_package.inches
  end

  test "self.origin creates a location object" do
    test_origin = Shipment.origin
    assert_instance_of ActiveShipping::Location, test_origin

    assert_equal test_origin.city, "Seattle"
    assert_equal test_origin.state, "WA"
  end

  test "self.destination creates a location object" do
    test_destination = Shipment.destination(DESTINATION_HASH)
    assert_instance_of ActiveShipping::Location, test_destination

    assert_equal DESTINATION_HASH[:city], test_destination.city
    assert_equal DESTINATION_HASH[:state], test_destination.state
    assert_equal DESTINATION_HASH[:postal_code], test_destination.postal_code
    assert_equal DESTINATION_HASH[:country], test_destination.country_code
  end
end

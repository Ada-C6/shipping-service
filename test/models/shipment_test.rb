require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase


  test "create a valid Shipment object" do
    ship_hash = {
      weight: 100.0,
      height: 12.0,
      length: 12.0,
      width: 12.0,
      city: "Las Vegas",
      state: "NV",
      country: "US",
      zipcode: "89121",
      units: "imperial"
    }

    shipment = Shipment.new(ship_hash)
    assert shipment.valid?
  end

  test "can't create a Shipment without a weight" do
    ship_hash = {
      height: 12.0,
      length: 12.0,
      width: 12.0,
      city: "Las Vegas",
      state: "NV",
      country: "US",
      zipcode: "89121",
      units: "imperial"
    }


      shipment = Shipment.new(ship_hash)
      assert_not shipment.valid?
      assert_includes shipment.errors, :weight
  end

  test "can't create a Shipment without a height" do
    ship_hash = {
      weight: 100.0,
      length: 12.0,
      width: 12.0,
      city: "Las Vegas",
      state: "NV",
      country: "US",
      zipcode: "89121",
      units: "imperial"
    }

    shipment = Shipment.new(ship_hash)
    assert_not shipment.valid?
    assert_includes shipment.errors, :height
  end

  test "can't create a Shipment without a length" do
    ship_hash = {
      weight: 100.0,
      height: 12.0,
      width: 12.0,
      city: "Las Vegas",
      state: "NV",
      country: "US",
      zipcode: "89121",
      units: "imperial"
    }

    shipment = Shipment.new(ship_hash)
    assert_not shipment.valid?
    assert_includes shipment.errors, :length


  end

  test "can't create a Shipment without a width" do
    ship_hash = {
      weight: 100.0,
      height: 12.0,
      length: 12.0,
      city: "Las Vegas",
      state: "NV",
      country: "US",
      zipcode: "89121",
      units: "imperial"
    }

    shipment = Shipment.new(ship_hash)
    assert_not shipment.valid?
    assert_includes shipment.errors, :width
  end

  test "can't create a Shipment without a city" do
    ship_hash = {
      weight: 100.0,
      height: 12.0,
      length: 12.0,
      width: 12.0,
      state: "NV",
      country: "US",
      zipcode: "89121",
      units: "imperial"
    }

  shipment = Shipment.new(ship_hash)
  assert_not shipment.valid?
  assert_includes shipment.errors, :city
  end

  test "can't create a Shipment without a state" do
    ship_hash = {
      weight: 100.0,
      height: 12.0,
      length: 12.0,
      width: 12.0,
      city: "Las Vegas",
      country: "US",
      zipcode: "89121",
      units: "imperial"
    }

    shipment = Shipment.new(ship_hash)
    assert_not shipment.valid?
    assert_includes shipment.errors, :state
  end


  test "can't create a Shipment without a country" do
    ship_hash = {
      weight: 100.0,
      height: 12.0,
      length: 12.0,
      width: 12.0,
      city: "Las Vegas",
      state: "NV",
      zipcode: "89121",
      units: "imperial"
    }

    shipment = Shipment.new(ship_hash)
    assert_not shipment.valid?
    assert_includes shipment.errors, :country
  end

  test "can't create a Shipment without a zipcode" do
    ship_hash = {
      weight: 100.0,
      height: 12.0,
      length: 12.0,
      width: 12.0,
      city: "Las Vegas",
      state: "NV",
      country: "US",
      units: "imperial"
    }

    shipment = Shipment.new(ship_hash)
    assert_not shipment.valid?
    assert_includes shipment.errors, :zipcode
  end

  test "can't create a Shipment without unit" do
    ship_hash = {
      weight: 100.0,
      height: 12.0,
      length: 12.0,
      width: 12.0,
      city: "Las Vegas",
      state: "NV",
      country: "US",
      zipcode: "89121",
    }

    shipment = Shipment.new(ship_hash)
    assert_not shipment.valid?
    assert_includes shipment.errors, :units
  end

  test "#origin returns a Location object" do
    shipment = shipments(:one)
    origin = shipment.origin
    assert_instance_of ActiveShipping::Location, origin
  end

  test "#destination returns a Location object" do
    shipment = shipments(:one)
    destination = shipment.destination
    assert_instance_of ActiveShipping::Location, destination

    assert_equal shipment.city, destination.city
    assert_equal shipment.state, destination.state
    assert_equal shipment.country, destination.country.name
    assert_equal shipment.zipcode, destination.postal_code
  end
end

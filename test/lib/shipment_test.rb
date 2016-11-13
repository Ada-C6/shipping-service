require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  test "can create a new instance of shipment" do #if some info is missing - the object will still be created, but the errors will occur in later methods
    VCR.use_cassette("test_shipments") do
      shipment_info_hash = {
        weight: 12,
        country: "US",
        state: "IN",
        city: "Osceola",
        zip: "46561"
      }
      new_shipment = Shipment.new(shipment_info_hash)
      assert_kind_of Shipment, new_shipment
      assert_not_nil new_shipment
      assert_equal shipment_info_hash[:city], new_shipment.dest_city

      assert_not_nil new_shipment.package
      assert_kind_of ActiveShipping::Package, new_shipment.package
      assert_not_nil new_shipment.origin
      assert_kind_of ActiveShipping::Location, new_shipment.origin
      assert_not_nil new_shipment.destination
      assert_kind_of ActiveShipping::Location, new_shipment.destination
    end
  end

  test "usps_quotes will return an array of arrays, each including shipping options" do
    VCR.use_cassette("test_shipments") do
      shipment_info_hash = {
        weight: 12,
        country: "US",
        state: "IN",
        city: "Osceola",
        zip: "46561"
      }
      new_shipment = Shipment.new(shipment_info_hash)

      usps = new_shipment.usps_quotes
      assert_kind_of Array, usps
      usps.each do |quote|
        assert_kind_of Array, quote
        assert_includes quote[0], "USPS"
        assert_kind_of Integer, quote[1]
      end
    end
  end

  test "usps_quotes will raise an error if given insufficient data" do #this error will be addressed in the controller
    VCR.use_cassette("test_shipments") do
      shipment_info_hash = {
        weight: 12,
        country: "US",
        state: "IN",
        city: "Osceola"
      }
      new_shipment = Shipment.new(shipment_info_hash)

      assert_raise ActiveShipping::ResponseError do
        new_shipment.usps_quotes
      end
    end
  end

  test "ups_quotes will raise an error if given insufficient data" do #this error will be addressed in the controller
    VCR.use_cassette("test_shipments") do
      shipment_info_hash = {
        weight: 12,
        country: "US",
        state: "IN",
        city: "Osceola"
      }
      new_shipment = Shipment.new(shipment_info_hash)

      assert_raise ActiveShipping::ResponseError do
        new_shipment.ups_quotes
      end
    end
  end

    test "ups_quotes will return an array of arrays, each including shipping options" do
      VCR.use_cassette("test_shipments") do
        shipment_info_hash = {
          weight: 12,
          country: "US",
          state: "IN",
          city: "Osceola",
          zip: "46561"
        }
        new_shipment = Shipment.new(shipment_info_hash)

        ups = new_shipment.ups_quotes
        assert_kind_of Array, ups
        ups.each do |quote|
          assert_kind_of Array, quote
          assert_includes quote[0], "UPS"
          assert_kind_of Integer, quote[1]
        end
      end
    end

    test "all_quotes will return an array of arrays including ups & usps quotes" do #any errors that might occur would be caused from the other methods and would be handled by the controller
      VCR.use_cassette("test_shipments") do
        shipment_info_hash = {
          weight: 12,
          country: "US",
          state: "IN",
          city: "Osceola",
          zip: "46561"
        }
        new_shipment = Shipment.new(shipment_info_hash)

        all = new_shipment.all_quotes
        assert_kind_of Array, all
        assert_includes all.first[0], "UPS"
        assert_includes all.last[0], "USPS"
        all.each do |quote|
          assert_kind_of Array, quote
          assert_kind_of Integer, quote[1]
        end
      end
    end


end

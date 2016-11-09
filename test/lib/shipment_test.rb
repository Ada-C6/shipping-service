require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  PACKAGE_PARAMS = {
    weight: 3.5,
    # dimensions: [15, 10, 4.5],
    length: 15,
    width: 10,
    height: 4.5
  }

  LOCATION_PARAMS = {
    country: "US",
    state: "CA",
    city: "Los Angeles",
    postal_code: "90078"
  }

  test "the truth" do
    assert true
  end

  test "self.package creates a package object" do
    test_package = Shipment.package(PACKAGE_PARAMS)
    assert_instance_of ActiveShipping::Package, test_package

    assert_equal PACKAGE_PARAMS[:weight], test_package.pounds
    assert_equal [4.5,10,15], test_package.pounds
  end
  #
  # test "creates a location object" do
  #   params = {
  #     weight: 3.5,
  #     # dimensions: [15, 10, 4.5],
  #     length: 15,
  #     width: 10,
  #     height: 4.5,
  #
  #     country: "US",
  #     state: "CA",
  #     city: "Los Angeles",
  #     postal_code: "90078"
  #   }
  #
  #   VCR.use_cassette("shipments") do
  #     get :index, params
  #
  #     assert_instance_of ActiveShipping::Location,assigns[:origin]
  #     assert_instance_of ActiveShipping::Location,assigns[:destination]
  #
  #     x = assigns[:origin]
  #     y = assigns[:destination]
  #     assert_equal params[:city], y.city
  #     assert_equal params[:state], y.state
  #
  #     assert_equal x.city, "Seattle"
  #     assert_equal x.state, "WA"
  #   end
  # end
end

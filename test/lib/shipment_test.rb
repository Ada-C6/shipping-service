require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  # test "creates a package object" do
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
  #     assert_instance_of ActiveShipping::Package, assigns[:package]
  #
  #     x = assigns[:package]
  #     assert_equal params[:weight], x.pounds
  #     assert_equal x.inches, [4.5, 10.0, 15.0]
  #   end
  # end
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

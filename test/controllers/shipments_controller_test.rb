require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase
  test "the truth" do
    assert true
  end

  test "can render index page" do
    get :index

    assert_response :success
  end

  test "#index returns json" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#create returns Shipment objects" do
    params = {
      package_weight: 3.5,
      package_dimensions: [15, 10, 4.5],

      destination_hash: {
        country: "US",
        state: "CA",
        city: "Los Angeles",
        postal_code: "90078"
      }
    }

    VCR.use_cassette("shipments") do
      post :create, params

      assert_instance_of Shipment, assigns[:package]
      assert_instance_of Shipment, assigns[:origin]
      assert_instance_of Shipment, assigns[:destination]
    end

  end
end

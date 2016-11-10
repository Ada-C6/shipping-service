require 'test_helper'
# require 'active_shipping'

class ShipmentsControllerTest < ActionController::TestCase
  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test "#create adds a new shipment to the database" do
    VCR.use_cassette("shipments") do
      shipment_data = { "weight" => 12.0, "height" => 12.0,
        "length" => 12.0, "width" => 12.0, "city" => "Las Vegas",
        "state" => "NV", "country" => "United States",
        "zipcode" => "89121", "units" => "imperial"}
      assert_difference('Shipment.count', 1) do
        post :create, {"shipment": shipment_data}
      end

      assert_response :created

      assert_match 'application/json', response.header['Content-Type']
      body = JSON.parse(response.body)
      assert_instance_of Hash, body

      assert_equal 1, body.keys.length
      assert_equal "id", body.keys.first

      shipment_from_database = Shipment.find(body["id"])

      assert_equal shipment_data["weight"], shipment_from_database.weight
    end    
  end

  # will return 400 error message if missing params
  test "#create will not add a new shipment to the database and render status 400 if there are missing inputs" do
    shipment_data = { "weight" => 12.0, "height" => 12.0,
      "length" => 12.0, "width" => 12.0}

    assert_difference('Shipment.count', 0) do
      post :create, {"shipment": shipment_data}
    end

    assert_response :bad_request
  end

  # where should Timeout error should go?
end

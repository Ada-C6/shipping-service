require 'test_helper'
# require 'active_shipping'

class ShipmentsControllerTest < ActionController::TestCase
  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  RATE_KEYS = %w( id service_name shipment_id total_price )

  # Should return a list of shipment services and their corresponding rates and delivery estimates
  test "can get #index" do
    get :index, { id: shipments(:one).id }
    assert_response :success
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#index returns an Array of Rate objects" do
    get :index, { id: shipments(:one).id }
    body = JSON.parse(response.body)
    assert_instance_of Array, body
  end

  test "returns one Rate object" do
    get :index, { id: shipments(:one).id }
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "each Rate object contains the relevant keys" do
    get :index, { id: shipments(:one).id }
    body = JSON.parse(response.body)
    assert_equal RATE_KEYS, body.map(&:keys).flatten.uniq.sort
  end


  test "create adds a new shipment to the database" do
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

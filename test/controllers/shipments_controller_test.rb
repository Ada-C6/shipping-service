require 'test_helper'
# require 'active_shipping'

class ShipmentsControllerTest < ActionController::TestCase
  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  # Should return a list of shipment services and their corresponding rates and delivery estimates
  test "can get #index" do
    get :index
    assert_response :success
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#index returns an Array of Shipment objects" do
    get :index
    body = JSON.parse(response.body)
    assert_instance_of Array, body
    assert_instance_of Shipment, body[0]
  end
end

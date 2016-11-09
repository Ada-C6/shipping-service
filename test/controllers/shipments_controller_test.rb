require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test "are the tests running" do
    assert true
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "#index returns an Array of Shipment objects" do
    get :index
    # Assign the result of the response from the controller action
    body = JSON.parse(response.body)
    assert_instance_of Array, body
    assert_equal body.length, 2
  end
end

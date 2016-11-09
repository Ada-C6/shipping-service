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
    get :index, {city: shipments(:one).city, weight: shipments(:one).weight, zip: shipments(:one).zip}
    assert_response :success
  end

  test "#index returns an Array" do
    get :index, {city: shipments(:one).city, weight: shipments(:one).weight, zip: shipments(:one).zip}
    # Assign the result of the response from the controller action
    body = JSON.parse(response.body)
    assert_kind_of Array, body
    assert_equal body.length, 14
    # assert_kind_of Quote, body.first
    # assert_equal body.first[2], "random"
  end





end

require 'test_helper'

class ShippingServicesControllerTest < ActionController::TestCase
  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test "can get index" do
    get :index
    assert_response :success
  end

  test "#index returns json" do
    get :index
    assert_match 'application/json',
    response.header['Content-Type']
  end

  test "#index returns an array of shipping service objects" do
    get :index
    body = JSON.parse(response.body)
    assert_instance_of Array, body

    #assert_instance_of ShippingDetail, body.first
  end
end

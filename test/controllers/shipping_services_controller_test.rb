require 'test_helper'

class ShippingServicesControllerTest < ActionController::TestCase
  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test "can get search" do
    get :search
    assert_response :success
  end

  test "#search returns json" do
    get :search
    assert_match 'application/json',
    response.header['Content-Type']
  end

  test "#search returns an array of shipping service objects" do
    get :search
    body = JSON.parse(response.body)
    assert_instance_of Array, body

    #assert_instance_of ShippingDetail, body.first
  end
end

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

  end

  test "should get show" do
    get :show, {id: quotes(:one)}
    assert_response :success
  end

  #TODO: WTF is going on here? What is the test that is failing?

  test "show returns json " do
    get :show, {id: quotes(:one).id }
    assert_match 'application/json', response.header['Content-Type']
    body = JSON.parse(response.body)
    assert_instance_of Hash, body

    # data set should match what we requested

    keys = %w(id name price)
    keys.each do |key|
      assert_equal body[key], quotes(:one)[key]
    end

    assert_equal keys, body.keys.sort
  end

  test "show for an ID that doesn't exists returns empty hash" do
    get :show, {id: 2222222}
    assert_response :no_content
    assert_equal response.body, "{}"
  end


end

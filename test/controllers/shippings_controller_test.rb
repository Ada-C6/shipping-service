require 'test_helper'

class ShippingsControllerTest < ActionController::TestCase

  setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
   end

  test "can get #index" do
    get :index
    assert_response :ok
  end

  test "#index returns json" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#index returns an Array of shipment options objects" do
    get :index
    # Assign the result of the response from the controller action
    body = JSON.parse(response.body)
    assert_instance_of Array, body
  end

  test "returns three pet objects" do
    get :index
    body = JSON.parse(response.body)
    assert_equal 3, body.length
  end

##################################
##### Adding model currently #####
##################################

  test "can get #show" do
    get :show, {carrier_name: 'ups'}
    assert_response :ok
  end

  test "#show returns json" do
    get :show, {carrier_name: 'ups'}
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#show returns an Hash of a Pet" do
    get :show, {carrier_name: 'ups'}
    # Assign the result of the response from the controller action
    body = JSON.parse(response.body)
    assert_instance_of Array, body
  end

  test "returns one pet objects with 4 key-values" do
    get :show, {carrier_name: 'ups'}
    body = JSON.parse(response.body)
    assert_equal 4, body.length
  end

  test "the one pet object contains the relevant keys" do
    keys = %w( age human id name )
    get :show, {carrier_name: 'ups'}
    body = JSON.parse(response.body)
    assert_equal keys, body.keys.sort
  end

  test "returns status no-content if not found" do
    get :show, {carrier_name: 'njsfjdiosks'}
    body = JSON.parse(response.body)
    assert_response :no_content
  end
end

require 'test_helper'

class ShippingControllerTest < ActionController::TestCase

  setup do
       @request.headers['Accept'] = Mime::JSON
       @request.headers['Content-Type'] = Mime::JSON.to_s
   end

  test "can get #index" do
    get :index
    assert_response :success
  end

  test "that index returns JSON" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end
end

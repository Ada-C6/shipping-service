require 'test_helper'

class ShippingServicesControllerTest < ActionController::TestCase
	setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
  	end

  test "should get show" do
    get :show
    assert_response :success
  end

end

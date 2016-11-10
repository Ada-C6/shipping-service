require 'test_helper'

class ShippingServicesControllerTest < ActionController::TestCase
	setup do
 		@request.headers['Accept'] = Mime::JSON
 		@request.headers['Content-Type'] = Mime::JSON.to_s
	end

  test "without being given the correct parameters, a 404 response is sent" do
    get :show
    assert_response :not_found
  end

  test "#show returns json" do
    get :show
    assert_match 'application/json', response.header['Content-Type']
  end

  test "when given all parameters, a success response is sent" do 
  	show_params={weight: '34', to:'23454', service: 'usps'}
  	get :show, show_params
    assert_response :success
  end

  test "when missing the weight, a 404 is sent with JSON error message" do 
  	show_params={weight: nil, to:'23454', service: 'usps'}
  	get :show, show_params
  	body=JSON.parse(response.body)
    assert_response :not_found
    assert body["error"]
  end

  test "when missing the zip, a 404 is sent with JSON error message" do 
  	show_params={weight: '24', to: nil, service: 'usps'}
  	get :show, show_params
  	body=JSON.parse(response.body)
    assert_response :not_found
    assert body["error"]
  end

  test "when missing the service, a 404 is sent with JSON error message" do 
  	show_params={weight: '24', to: '23453', service: nil}
  	get :show, show_params
  	body=JSON.parse(response.body)
    assert_response :not_found
    assert body["error"]
  end
end

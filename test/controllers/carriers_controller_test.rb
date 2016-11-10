require 'test_helper'
require 'rails/test_help'
require 'minitest/reporters'

class CarriersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_match 'application/json', response.header['Content-Type']
  end

  test "index returns list of carriers" do
    get :index
    body = JSON.parse(response.body)
    assert_instance_of Array, body
    assert_equal 3, body.length
    assert_equal body, ["UPS", "USPS", "Fedex"]
  end

end

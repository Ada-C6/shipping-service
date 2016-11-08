require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase
  test "the truth" do
    assert true
  end

  test "can render index page" do
    get :index

    assert_response :success
  end

  test "#index returns json" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end
end

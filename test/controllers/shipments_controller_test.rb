require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase
  test "are the tests running" do
    assert true
  end

  test "should get index" do
    get :index
    assert_response :success
  end
end

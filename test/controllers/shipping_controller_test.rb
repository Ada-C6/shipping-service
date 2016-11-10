require 'test_helper'

class ShippingControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @params = {weight: 100, height: 10, length: 10, width: 10, country: "USA", city: "cat", state: "MI", zip: 29393}
  end

  test "quote returns json" do
    post :quote, packages: @params
    assert_match 'application/json', response.header['Content-Type']
  end

  test 'posting a quote returns a 201 created?' do
    post :quote, packages: @params
    assert_response :created
  end

  test 'when params is missing something, should return ?? ' do
    @params[:weight] = nil
    post :quote, packages: @params
    assert_response :bad_request
  end
end

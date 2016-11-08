require 'test_helper'

class ShippingQuotesControllerTest < ActionController::TestCase
  test "#index returns json" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end
  
end

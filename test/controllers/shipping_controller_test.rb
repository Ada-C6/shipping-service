require 'test_helper'
require 'json'

class ShippingControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
   end

  def setup
    @params = {:carrier => 'usps',
      packages: [{weight: 100, height: 10, length: 10, width: 10}],
      country: "USA",
      city: "cat",
      state: "MI",
      zip: 98119}
  end

  test "quote returns json" do
    post :quote, @params
    assert_match 'application/json', response.header['Content-Type']
  end

  test 'posting a quote returns a 201 created' do
    post :quote, @params
    assert_response :created
  end

  test 'when params is missing carrier, should return 400 bad request with meaningful error message' do
    @params[:carrier] = nil
    post :quote, @params
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_instance_of(Hash, body)
    assert_equal(body["error"], "must specify carrier field")
  end

  test 'when params has unsupported carrier, should return 400 bad request with meaningful error message' do
    @params[:carrier] = "cats"
    post :quote, @params
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_instance_of(Hash, body)
    assert_equal(body["error"], "must specify a carrier from #{ShipWrapper.valid_carriers.join(', ')}")
  end

end

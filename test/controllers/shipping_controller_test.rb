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

  test 'when :packages param is not present, should return a 400 bad request w/ error message' do
    @params[:packages] = nil
    post :quote, @params
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_instance_of(Hash, body)
    assert_equal(body["error"], "missing packages field")
  end

  test 'when :packages param present but not an array, should return a 400 bad request w/ error message' do
    @params[:packages] = "cat"
    post :quote, @params
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_instance_of(Hash, body)
    assert_equal(body["error"], "packages field must be an array of package hash")
  end

  test 'when :packages param is empty should return 400 w error msg' do
    @params[:packages] = []
    post :quote, @params
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_instance_of(Hash, body)
    assert_equal(body["error"], "packages field must not be empty")
  end

  test 'when packages is correct except that its elements are not a hash, yet again return an error' do
    @params[:packages] = [["length", "width", 100], ["cat", "blah"], 'blue']
    post :quote, @params
    assert_response :bad_request
    body = JSON.parse(response.body)
    assert_instance_of(Hash, body)
    assert_equal(body["error"], "packages field must be an array of package hash")
  end

  test 'when packages is missing an element, should get an error back' do
    def helper_method
      post :quote, @params
      assert_response :bad_request
      body = JSON.parse(response.body)
      assert_instance_of(Hash, body)
      assert_equal(body["error"], "package hash must have 'weight', 'height', 'length', 'width'")
    end

    @params[:packages][0][:weight] = nil
    helper_method
    @params[:packages][0][:weight] = 10
    @params[:packages][0][:height] = nil
    helper_method
    @params[:packages][0][:height] = 10
    @params[:packages][0][:length] = nil
    helper_method
    @params[:packages][0][:length] = 10
    @params[:packages][0][:width] = nil
    helper_method

  end

  test 'when address is missing an element, should get an error back' do
    def address_helper_method(error)
      post :quote, @params
      assert_response :bad_request
      body = JSON.parse(response.body)
      assert_instance_of(Hash, body)
      assert_equal(body["error"], "missing '#{error}' field")
    end

    @params[:country] = nil
    address_helper_method("country")
    @params[:country] = "cat"
    @params[:city] = nil
    address_helper_method("city")
    @params[:city] = "cat"
    @params[:state] = nil
    address_helper_method("state")
    @params[:state] = "cat"
    @params[:zip] = nil
    address_helper_method("zip")

  end

end

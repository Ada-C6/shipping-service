require 'test_helper'

class ShippingServicesControllerTest < ActionController::TestCase
  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test "can get search" do
    VCR.use_cassette("shipments") do
      get :search, { origin: '98101', destination: '98107', package: 10 }
      assert_response :success
    end
  end

  test "#search returns json" do
    VCR.use_cassette("shipments") do
      get :search,  { origin: '98101', destination: '98107', package: 10 }
      assert_match 'application/json',
      response.header['Content-Type']
    end
  end

  test "#search returns an array of JSON hashes" do
    VCR.use_cassette("shipments") do
      get :search,  { origin: '98101', destination: '98107', package: 10 }
      body = JSON.parse(response.body)
      assert_instance_of Array, body

      assert_instance_of Hash, body.first
    end
  end
end

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

  test "each option object contains the relevant keys" do
    VCR.use_cassette("shipments") do
      keys = %w( cost id name  )
      get :search, { origin: '98101', destination: '98107', package: 10 }

      body = JSON.parse(response.body)
      assert_equal keys, body.map(&:keys).flatten.uniq.sort
    end
  end

  test "given an id, show returns a json hash for that shipping option" do

    keys = %w( cost id name )
    get :show, { id: shipping_options(:one).id }

    body = JSON.parse(response.body)

    assert_instance_of Hash, body

    # This is checking that the values at each of the keys equals what we think it should.
    keys.each do |key|
       assert_equal body[key], shipping_options(:one)[key]
     end

     # make sure there are only the keys we want
     assert_equal keys, body.keys.sort
  end

  test "given an id that doesn't exist, show returns not found" do
    get :show, { id: ShippingOption.last.id + 1 }

    assert_response :not_found

    assert_empty response.body
  end
end

require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase
  setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
   end

   TEST_PARAMS = {
     weight: 3.5,
     # dimensions: [15, 10, 4.5],
     length: 15,
     width: 10,
     height: 4.5,

     country: "US",
     state: "CA",
     city: "Los Angeles",
     billing_zip: "90078"
   }

  test "the truth" do
    assert true
  end

  test "can render index page" do
    VCR.use_cassette("shipments") do
      get :index, TEST_PARAMS

      assert_response :success
    end
  end

  test "#index returns json" do
    VCR.use_cassette("shipments") do
      get :index, TEST_PARAMS

      assert_match 'application/json', response.header['Content-Type']
    end
  end

  test "each shipment object contains the relevant keys" do
    VCR.use_cassette("shipments") do
      keys = %w(carrier service_name total_price)

      get :index, TEST_PARAMS

      body = JSON.parse(response.body)
      body.each do |carrier|
        carrier_keys = carrier[1][1].keys
        assert_equal keys, carrier_keys.sort
        assert_equal carrier_keys.length, 3
      end
    end
  end

  test "#index renders an hash of objects" do
    VCR.use_cassette("shipments") do
      get :index, TEST_PARAMS

      body = JSON.parse(response.body)
      assert_instance_of Hash, body
      assert_response :success
    end
  end

  test "#index sends 404 status for bad address" do
    VCR.use_cassette("shipments") do
      bad_data = {
        weight: 3.5,
        length: 15,
        width: 10,
        height: 4.5,

        country: "US",
        state: "CA",
        city: "Los Angeles",
        billing_zip: nil
      }

      get :index, bad_data
      assert_response :not_found
    end
  end

>>>>>>> nicole/shipping
end

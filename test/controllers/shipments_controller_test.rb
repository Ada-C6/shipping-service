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
     postal_code: "90078"
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

  # test "appropriate associated objects are created in the #index" do
  #   VCR.use_cassette("shipments") do
  #     get :index, TEST_PARAMS
  #
  #     package = assigns[:package]
  #
  #     assert_instance_of ActiveShipping::Package, package
  #     assert_instance_of ActiveShipping::Location,assigns[:origin]
  #     assert_instance_of ActiveShipping::Location,assigns[:destination]
  #
  #     assert_equal TEST_PARAMS[:weight], package.pounds
  #     assert_equal package.inches, [4.5, 10.0, 15.0]
  #
  #     origin = assigns[:origin]
  #     destination = assigns[:destination]
  #     assert_equal TEST_PARAMS[:city], destination.city
  #     assert_equal TEST_PARAMS[:state], destination.state
  #     assert_equal origin.city, "Seattle"
  #     assert_equal origin.state, "WA"
  #
  #     assert_response :success
  #   end
  # end

  # test "ups_rates and usps_rates each returns an array of shipping options" do
  #   VCR.use_cassette("shipments") do
  #     get :index, TEST_PARAMS
  #
  #     ups = assigns[:ups_rates]
  #     usps = assigns[:usps_rates]
  #
  #     assert_instance_of Array, ups
  #     assert_instance_of Array, usps
  #   end
  # end

  test "#index returns json" do
    VCR.use_cassette("shipments") do
      get :index, TEST_PARAMS

      assert_match 'application/json', response.header['Content-Type']
    end
  end

  # test "#index returns an hash of objects" do
  #   VCR.use_cassette("shipments") do
  #     get :index, TEST_PARAMS
  #     # Assign the result of the response from the controller action
  #     all_shipping_options = assigns[:all_shipping_options]
  #     assert_instance_of Hash, all_shipping_options
  #     body = JSON.parse(response.body)
  #     assert_instance_of Hash, body
  #   end
  # end
end

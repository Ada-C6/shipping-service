require 'test_helper'

class QuotesControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
    @good_request = {
       "weight"=> 3,
        "destination"=>
          {
               "country"=> "US",
                "city"=> "Los Angeles",
                "state"=> "CA",
                "zip"=> "90032"
          }
    }
  end

  test "#create should create a new Quote with relevant keys" do
    # attributes = %w(package origin destination)
    # weight =
    # post :create { }
  end

  test "#create should render JSON" do
    VCR.use_cassette("quotes") do
      post :create, @good_request
      assert_match 'application/json', response.header['Content-Type']
      assert_response :ok
    end
  end

  test "#create should return hash of carriers as keys and hash of rates for each value" do
    VCR.use_cassette("quotes") do
      carriers = %w(ups usps)
      post :create, @good_request
      body = JSON.parse(response.body)

      assert_instance_of Hash, body
      assert_equal carriers, body.keys
      carriers.each do |k|
        assert_instance_of Hash, body[k]
      end
    end

  end

  test "#create, each UPS rate hash has shipping service as key and value is an array" do
    VCR.use_cassette("quotes") do

      ups_shipping_services = ["UPS Ground", "UPS Three-Day Select", "UPS Second Day Air", "UPS Next Day Air Saver", "UPS Next Day Air", "UPS Next Day Air Early A.M."]

      post :create, @good_request
      body = JSON.parse(response.body)

      assert_equal body["ups"].keys, ups_shipping_services
      assert_instance_of Array, body["ups"].values.first
    end
  end

  test "#create, each USPS rate hash has shipping service as key and value is an array" do
    VCR.use_cassette("quotes") do

      usps_shipping_services = ["USPS Library Mail Parcel", "USPS Media Mail Parcel", "USPS Retail Ground", "USPS Priority Mail 3-Day", "USPS Priority Mail Express 2-Day", "USPS Priority Mail Express 2-Day Hold For Pickup"]

      post :create, @good_request
      body = JSON.parse(response.body)

      assert_equal body["usps"].keys, usps_shipping_services
      assert_instance_of Array, body["usps"].values.first
    end
  end

  test "#create, each rate hash value array consists of a cost and  estimated delivery_date if it exists" do
    VCR.use_cassette("quotes") do

      ups_shipping_services = ["UPS Ground", "UPS Three-Day Select", "UPS Second Day Air", "UPS Next Day Air Saver", "UPS Next Day Air", "UPS Next Day Air Early A.M."]

      post :create, @good_request
      body = JSON.parse(response.body)

      body["ups"].values.each do |v|
        assert_instance_of Fixnum, v.first
      end
    end
  end

  test "#create will render an error if you do not provide a weight" do
    VCR.use_cassette("quotes") do
      request_no_weight = {
          "destination"=>
            {
                 "country"=> "US",
                  "city"=> "Los Angeles",
                  "state"=> "CA",
                  "zip"=> "90032"
            }
      }
      expected_response = {
        "error" => "Must supply a weight to calculate quote."
      }
      post :create, request_no_weight
      body = JSON.parse(response.body)
      assert_equal expected_response, body
      assert_response 400
    end
  end
  test "#create will render an error if Active Shipping detects an error from bad location input" do
    VCR.use_cassette("quotes") do
      bad_request = {
          "weight"=> 3,
          "destination"=>
            {
                 "country"=> "US",
                  "city"=> "Los Angeles",
                  "state"=> "CAL",
                  "zip"=> "11231"
            }
      }
      post :create, bad_request
      body = JSON.parse(response.body)
      assert_includes body.keys, "error"
      assert_includes body["error"], "Failure"
      assert_response 400
    end
  end

end

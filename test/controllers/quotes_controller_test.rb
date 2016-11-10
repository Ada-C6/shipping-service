require 'test_helper'

class QuotesControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test "#create should create a new Quote with relevant keys" do
    # attributes = %w(package origin destination)
    # weight =
    # post :create { }
  end

  test "#create should render JSON" do
    VCR.use_cassette("quotes") do
      request = {
  	     "weight"=> 3,
  	      "destination"=>
  		      {
  			         "country"=> "US",
  			          "city"=> "Los Angeles",
  			          "state"=> "CA",
  			          "zip"=> "90032"
  		      }
      }
      post :create, request
      assert_match 'application/json', response.header['Content-Type']
      assert_response :ok
    end
  end

  test "#create should return hash of carriers as keys and hash of rates as values" do
    keys = %w(ups usps)

  end

  test "#create, each rate hash has shipping service as key and value is an array" do

  end

  test "#create, each rate hash value array consists of a cost and  estimated delivery_date if it exists" do

  end
end

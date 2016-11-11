require 'test_helper'

class ShippingQuotesControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  ORDER = {"weight"=>8.0, "origin"=>{"origin_country"=>"US", "origin_state"=>"WA", "origin_city"=>"Seattle", "origin_zip"=>"98104"}, "destination"=>{"destination_country"=>"US", "destination_state"=>"IL", "destination_city"=>"Skokie", "destination_zip"=>"60076"}}

  test "#index returns json" do
    VCR.use_cassette("active_shipping") do
      get :index, ORDER
      assert_match 'application/json', response.header['Content-Type']
    end
  end

  test "#index returns an Array of ShippingQuote objects" do
    VCR.use_cassette("active_shipping") do
      get :index, ORDER
      body = JSON.parse(response.body)
      assert_instance_of Array, body
    end
  end

end

require 'test_helper'
require 'active_shipping'

class ShipmentsControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  # REWRITE THIS TEST COPIED FROM MODEL TEST
  test "(index) #get_rates_from_shipper returns json and all rates for user" do

    get :index, params: { weight: 20, country: "US", zip: "98136" }

    assert_match 'application/json', response.header['Content-Type']

    body = JSON.parse(response.body)
    assert_instance_of Array, body

    body.each do |array_item|
      array_item.each do |hash|
        assert_kind_of Hash, hash
      end
    end
  end

  test "(show) should return one of many potential carrier's rate estimate info" do

    get :show, { carrier: "ups" }
    assert_match 'application/json', response.header['Content-Type']

    body = JSON.parse(response.body)
    assert_instance_of Array, body

    body.each do |obj|
      assert_kind_of RateEstimate, obj
    end

  end


end

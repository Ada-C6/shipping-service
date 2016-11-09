require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  # REWRITE THIS TEST COPIED FROM MODEL TEST
  test "(index) #get_rates_from_shipper returns json and all rates for user" do
    get :index, {weight: 15, length: 10, width: 10, height: 10}
    assert_match 'application/json', response.header['Content-Type']

    body = JSON.parse(response.body)
    assert_instance_of Array, body

    body.each do |obj|
      assert_kind_of RateEstimate, obj
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

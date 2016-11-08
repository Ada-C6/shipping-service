require 'test_helper'

class ShipmentControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  REWRITE THIS TEST COPIED FROM MODEL TEST
  test "#get_rates_from_shipper returns json and rates from shipper" do
    get_rates_from_shipper
    assert_match 'application/json', response.header['Content-Type']

    body = JSON.parse(response.body)
    assert_instance_of Array, body

    body.each do |obj|
      assert_kind_of RateEstimate, obj
    end
  end


end

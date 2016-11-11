require 'test_helper'
require 'active_shipping'

class ShipmentsControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test "create returns json and all rates for user" do
    post :create, { weight: 20, country: "US", state: "WA", city: "Seattle", zip: "98136" }

    assert_match 'application/json', response.header['Content-Type']

    body = JSON.parse(response.body)
    assert_instance_of Hash, body

    body.keys.each do |k|
      assert_kind_of String, k
    end

    body.values.each do |v|
      assert_kind_of Array, v
    end
  end

  # TODO: Not working atm
  # test "do not create new shipment without all valid params" do
  #   assert_no_difference('Shipment.count') do
  #     post :create, { weight: nil, country: nil, state: nil, city: nil, zip: nil }
  #   end
  # end
end

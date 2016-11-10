require 'test_helper'
require 'active_shipping'

class ShipmentsControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  def origin
    ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", zip: "98161")
  end

  test "create returns json and all rates for user" do

    post :create, { weight: 20, country: "US", state: "WA", city: "Seattle", zip: "98136" }

    assert_match 'application/json', response.header['Content-Type']

    body = JSON.parse(response.body)
    assert_instance_of Hash, body

    body.each do |item|
      assert_kind_of Array, item
    end
  end

  # test "(show) should return one of many potential carrier's rate estimate info" do
  #
  #   get :show, { carrier: "ups" }
  #   assert_match 'application/json', response.header['Content-Type']
  #
  #   body = JSON.parse(response.body)
  #   assert_instance_of Array, body
  #
  #   body.each do |obj|
  #     assert_kind_of RateEstimate, obj
  #   end

  # end


end

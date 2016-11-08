require 'test_helper'

class ShippingControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  RATE_KEYS = %w( cost id name )

  test "search will return an array of json objects" do
    get :search, { weight: 10,
      origin_country: "US",
      origin_state: "WA",
      origin_city: "Seattle",
      origin_zip: "98122",
      destination_country: "US",
      destination_state: "NY",
      destination_city: "Brooklyn",
      destination_zip: "11206" }
    assert_response :success

    assert_match 'application/json', response.header['Content-Type']
    body = JSON.parse(response.body)

    puts body

    assert_instance_of Array, body

    body.each do |rate|
      assert_instance_of Hash, rate
      # # @todo - this segment could be useful once fixtures
      # RATE_KEYS.each do |key|
      #   value_from_server = rate[key]
      #   value_from_fixture = rate(:three)[key]
      #   assert_equal value_from_server, value_from_fixture
      # end
      assert_equal RATE_KEYS, rate.keys.sort
    end

  end

  # test "search_rates will " do
  #
  # end
  #
  # test "" do
  #
  # end
  #
  # test "" do
  #
  # end
  #
  # test "" do
  #
  # end
  #
  # test "" do
  #
  # end

end

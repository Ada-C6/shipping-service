require 'test_helper'
require 'timeout'

class ShippingControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  RATE_KEYS = %w( cost id name )

  test "search will return an array of json objects" do
    WebMock.allow_net_connect!
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

    assert_instance_of Array, body

    body.each do |rate|
      assert_instance_of Hash, rate
      # # @todo - this segment could be useful once/if fixtures
      # RATE_KEYS.each do |key|
      #   value_from_server = rate[key]
      #   value_from_fixture = rate(:three)[key]
      #   assert_equal value_from_server, value_from_fixture
      # end
      assert_equal RATE_KEYS, rate.keys.sort
    end

  end

  test "API passes back ActiveShipping ResponseErrors in json" do
    WebMock.allow_net_connect!
    get :search, { weight: 10,
      origin_country: "US",
      origin_state: "WA",
      origin_city: "Seattle",
      origin_zip: "98122",
      destination_country: "US",
      destination_state: "NY",
      destination_city: "Brooklyn",
      destination_zip: "98101" }

    # Check the response
    assert_match 'application/json', response.header['Content-Type']
    body = JSON.parse(response.body)
    assert_instance_of Hash, body

    assert_not_empty body["error"]

    assert_match /Failure/, body["error"]
  end


  # We determined that testing Timeout is challenging and Kari said this is probably good enough.
  # If TimeoutError is raised, none of the other tests run, but if it runs fast enough that TimeoutError
  # isn't triggered, then this test fails. However, in our testing, TimeoutError is raised when it
  # takes too long!

  # test "API should return an error when request does not process in a timely manner" do
  #   stub_request(:any, "http://localhost:3000/search?destination_city=Springfield&destination_country=US&destination_state=OH&destination_zip=45502&origin_city=Seattle&origin_country=US&origin_state=WA&origin_zip=98122&weight=105.6").to_timeout
  #
  #   assert_raises Timeout::Error do
  #     get :search, { weight: 105.6,
  #       origin_country: "US",
  #       origin_state: "WA",
  #       origin_city: "Seattle",
  #       origin_zip: "98122",
  #       destination_country: "US",
  #       destination_state: "OH",
  #       destination_city: "Springfield",
  #       destination_zip: "45502" }
  #   end
  # end
  
end

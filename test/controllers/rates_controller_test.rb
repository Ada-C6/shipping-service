require 'test_helper'

class RatesControllerTest < ActionController::TestCase
  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  RATE_KEYS = %w( id service_name shipment_id total_price )

  # Should return a list of shipment services and their corresponding rates and delivery estimates
  test "can get #index" do
    get :index, { shipment_id: shipments(:one).id, id: rates(:one).id }
    assert_response :success
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#index returns an Array of Rate objects" do
    get :index, { shipment_id: shipments(:one).id, id: rates(:one).id }
    body = JSON.parse(response.body)
    assert_instance_of Array, body
  end

  test "#index returns the correct number of Rate objects associated with a shipment" do
    get :index, { shipment_id: shipments(:one).id, id: rates(:one).id }
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "each Rate object returned by #index contains the relevant keys" do
    get :index, { shipment_id: shipments(:one).id, id: rates(:one).id }
    body = JSON.parse(response.body)
    assert_equal RATE_KEYS, body.map(&:keys).flatten.uniq.sort
  end

  test "can #show a Rate that exists" do
    get :show, { id: rates(:one).id }
    assert_response :success

    assert_match 'application/json', response.header['Content-Type']
    body = JSON.parse(response.body)
    assert_instance_of Hash, body
  end

  test "#show for a id that doesn't exist returns no content" do
    get :show, { id: 12345 }
    assert_response :not_found
    assert_empty response.body
  end
end

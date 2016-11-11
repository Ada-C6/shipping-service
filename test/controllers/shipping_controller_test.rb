require 'test_helper'

class ShippingControllerTest < ActionController::TestCase

  setup do
       @request.headers['Accept'] = Mime::JSON
       @request.headers['Content-Type'] = Mime::JSON.to_s
   end

  test "can get #index" do
    get :index
    assert_response :success
  end

  test "that index returns JSON" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end

  test "when #create is invoked, a shipment is made" do
    shipment_data = { "country" => "#{shippings(:destination_two).country}", "state" => "#{shippings(:destination_two).state}", "city" => "#{shippings(:destination_two).city}", "zip" => "#{shippings(:destination_two).zip}", "weights" => "#{shippings(:weights_two).weights}" }
    assert_difference('Shipping.count', 1) do
      post :create, { "shipping": shipment_data }
    end
    assert_response :created

    # Check response
    assert_match 'application/json', response.header['Content-Type']
    body = JSON.parse(response.body)
    assert_instance_of Hash, body

    # Check the returned data
    assert_equal 2, body.keys.length
    assert_equal "id", body.keys.first
    assert_equal 14, body.keys[1].length

    shipment_from_database = Shipping.find(body["id"])
    assert_equal shipment_data["zip"], shipment_from_database.zip
  end


end

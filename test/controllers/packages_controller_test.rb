require 'test_helper'
require 'active_shipping'

class PackagesControllerTest < ActionController::TestCase

  setup do
    @request.headers['Accept'] = Mime::JSON
    @request.headers['Content-Type'] = Mime::JSON.to_s
  end

  test "when #find_rate invoked package rate is returned" do
    params = {
      "weight" => 10,
      "state" => "WA",
      "city" => "Seattle",
      "zip" => "98102"
    }
    post :find_rate, params

    assert_match 'application/json', response.header['Content-Type']
    body = JSON.parse(response.body)

    assert_instance_of Hash, body
    assert_response :created
  end

  test "an ActiveShipping::ResponseError with invalid zipcode" do
    get :find_rate,  {
      "weight" => 10,
      "state" => "WA",
      "city" => "Seattle",
      "zip" => "99999"
    }

    body = JSON.parse(response.body)

    assert_equal body, {"error" => "The Destination ZIP Code you have entered is invalid."}
  end

  test "an ActiveShipping::ResponseError with a weight over 90 pounds" do
    get :find_rate,  {
      "weight" => 100000,
      "state" => "WA",
      "city" => "Seattle",
      "zip" => "99999"
    }

    body = JSON.parse(response.body)

    assert_equal body, {"error" => "Warning - The package weight cannot exceed 70 pounds.  "}
  end

  test "an ActiveShipping::ResponseError when the zipcode does not match the state" do
    get :find_rate,  {
      "weight" => 10,
      "state" => "WA",
      "city" => "Seattle",
      "zip" => "02131"
    }

    body = JSON.parse(response.body)

    assert_equal body, {"error" => "Failure: The postal code 02131 is invalid for WA United States."}
  end

  test "State must be written in the two character form" do
    get :find_rate,  {
      "weight" => 10,
      "state" => "Washington",
      "city" => "Seattle",
      "zip" => "98118"
    }

    body = JSON.parse(response.body)

    assert_equal body, {"error" => "Failure: Washington is not a valid state for the specified shipment."}
  end

  test "ActiveShipping::ResponseError when an invalid state is provided" do
    get :find_rate,  {
      "weight" => 10,
      "state" => "YZ",
      "city" => "Seattle",
      "zip" => "98118"
    }

    body = JSON.parse(response.body)

    assert_equal body, {"error" => "Failure: YZ is not a valid state for the specified shipment."}
  end
end

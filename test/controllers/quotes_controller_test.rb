require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
    setup do
        @request.headers['Accept'] = Mime::JSON
        @request.headers['Content-Type'] = Mime::JSON.to_s
    end

    test "can get #index" do
        get :index
        assert_response :success
    end

    test "#index returns json" do
        get :index
        assert_match 'application/json', response.header['Content-Type']
    end

    # test "#index returns an Array of Quotes objects" do
    #     get :index
    #     # Assign the result of the response from the controller action
    #     body = JSON.parse(response.body)
    #     assert_instance_of Array, body
    # end
    #
    # test "returns three quote objects" do
    #     get :index
    #     body = JSON.parse(response.body)
    #     assert_equal 3, body.length
    # end
    #
    # test "each quote object contains the relevant keys" do
    #     keys = %w( age human id name )
    #     get :index
    #     body = JSON.parse(response.body)
    #     assert_equal keys, body.map(&:keys).flatten.uniq.sort
    # end
end

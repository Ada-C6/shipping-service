require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
    # required setup to make sure we support the API JSON type...
    setup do
        @request.headers['Accept'] = Mime::JSON
        @request.headers['Content-Type'] = Mime::JSON.to_s
    end

    test "can get #index" do
        VCR.use_cassette "test_shipments" do
            get :index
            assert_response :success
        end
    end

    test "#index returns json" do
        VCR.use_cassette "test_shipments" do
            get :index
            assert_match 'application/json', response.header['Content-Type']
        end
    end

    test "#index returns a Hash with a 'quotes' key that has a value that is an Array of Arrays, with each inner array having two elements, the carrier/method and the price of that specific quote (in cents)" do
        VCR.use_cassette "test_shipments" do
            get :index
            # Assign the result of the response from the controller action
            body = JSON.parse(response.body)
            assert_instance_of Hash, body
            hash_value = body["quotes"]

            hash_value.each do |element|
                assert_instance_of Array, element
                assert_instance_of String, element[0]
                # testing that each of these carrier/method elements has a 'PS' in them, for either UPS or USPS:
                assert_equal true, element[0].include?("PS")
                assert_instance_of Fixnum, element[1]
            end
        end
    end

    # test "#index with missing shipping_info_hash input will return no content--negative test case" do
    #     VCR.use_cassette "test_shipments" do
    #         VCR.use_cassette "missing_shipment_info" do
    #             get :index
    #             assert_response :not_found
    #             assert_empty response.body
    #         end
    #     end
    # end
end

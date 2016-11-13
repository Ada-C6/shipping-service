require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase

  test "Can receive a valid set of quotes from shippers" do
    VCR.use_cassette("quotes") do
      get :index, {weight: 2, origin_zip: 98122, destination_zip: 98122}
      body = JSON.parse(response.body)
      assert_instance_of Hash, body
      assert_response :success
      assert_equal 3, body.length
    end
  end

  test "correct quote for a shipment" do
    VCR.use_cassette("correct_quote") do
      get :index, {weight: 2, origin_zip: 98122, destination_zip: 98122}

      JSON.parse(response.body)["UPS"].each do |array|
        assert array[0].include?("UPS")
        assert array[1].is_a?(Integer)
      end

      JSON.parse(response.body)["USPS"].each do |array|
        assert array[0].include?("USPS")
        assert array[1].is_a?(Integer)
      end

      JSON.parse(response.body)["Fedex"].each do |array|
        assert array[0].include?("FedEx")
        assert array[1].is_a?(Integer)
      end

    end
  end

  test "a quote for a shipment that's too heavy" do
    VCR.use_cassette("too_heavy") do
      get :index, {weight: 151, origin_zip: 98122, destination_zip: 98122}
      assert_response :missing #could also be 404
      assert_equal JSON.parse(response.body)["error"], "UH-OH. LOOKS LIKE SOMETHING'S NOT QUITE RIGHT. PERHAPS YOUR ZIP CODES ARE OFF BY ONE? PLEASE NOTE: PACKAGES HAVE A WEIGHT LIMIT OF 150 LBS AND SHIPMENTS ARE ONLY ALLOWED WITHIN THE UNITED STATES."

      get :index, {weight: 71, origin_zip: 98122, destination_zip: 98122}
      assert_response :ok
      assert_equal JSON.parse(response.body)["USPS"], "USPS CAN ONLY SHIP PACKAGES WEIGHING 70 LBS OR LESS."

      JSON.parse(response.body)["UPS"].each do |array|
        assert array[1].is_a?(Integer)
      end

      JSON.parse(response.body)["Fedex"].each do |array|
        assert array[1].is_a?(Integer)
      end

    end
  end

  test "incorrect zip codes" do
    VCR.use_cassette("invalid_zip") do
      get :index, {weight: 3, origin_zip: 1234, destination_zip: 98122}
      assert_response :missing #could also be 404
      assert_equal JSON.parse(response.body)["error"], "UH-OH. LOOKS LIKE SOMETHING'S NOT QUITE RIGHT. PERHAPS YOUR ZIP CODES ARE OFF BY ONE? PLEASE NOTE: PACKAGES HAVE A WEIGHT LIMIT OF 150 LBS AND SHIPMENTS ARE ONLY ALLOWED WITHIN THE UNITED STATES."

      get :index, {weight: 71, origin_zip: 98122, destination_zip: 9812}
      assert_response :missing #could also be 404
      assert_equal JSON.parse(response.body)["error"], "UH-OH. LOOKS LIKE SOMETHING'S NOT QUITE RIGHT. PERHAPS YOUR ZIP CODES ARE OFF BY ONE? PLEASE NOTE: PACKAGES HAVE A WEIGHT LIMIT OF 150 LBS AND SHIPMENTS ARE ONLY ALLOWED WITHIN THE UNITED STATES."

      get :index, {weight: 71, origin_zip: 98122}
      assert_response :missing #could also be 404
      assert_equal JSON.parse(response.body)["error"], "UH-OH. LOOKS LIKE SOMETHING'S NOT QUITE RIGHT. PERHAPS YOUR ZIP CODES ARE OFF BY ONE? PLEASE NOTE: PACKAGES HAVE A WEIGHT LIMIT OF 150 LBS AND SHIPMENTS ARE ONLY ALLOWED WITHIN THE UNITED STATES."
    end
  end

end

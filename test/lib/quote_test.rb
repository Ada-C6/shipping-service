require 'test_helper'

class QuoteTest < ActiveSupport::TestCase

  def setup
    weight = 3
    origin = { country: 'US', state: 'WA', city: 'Seattle', zip: '98151' }
    destination = { country: 'US', state: 'CA', city: 'Los Angeles', zip: '90032' }
    dimensions = [15, 10, 4.5]
    @quote = Quote.new(weight, origin, destination, dimensions)

    # @negatory = Quote.new(nil, origin, destination, dimensions)
  end
  test "that tests are working" do
    assert true
  end

  test "should #initialize with weight, origin, destination, dimensions" do
    assert_instance_of Quote, @quote
  end

  test "on #intialize should create new package, origin and destination with Active Shipping gem" do
    assert_instance_of ActiveShipping::Package, @quote.package
    assert_instance_of ActiveShipping::Location, @quote.origin
    assert_instance_of ActiveShipping::Location, @quote.destination
  end

  test "calling #ups will return a hash of rates from UPS with different service names" do
    VCR.use_cassette("quote") do
      keys = ["UPS Ground", "UPS Three-Day Select", "UPS Second Day Air", "UPS Next Day Air Saver", "UPS Next Day Air", "UPS Next Day Air Early A.M."]

      assert_instance_of Hash, @quote.ups
      assert_equal 6, @quote.ups.length
      assert_equal keys, @quote.ups.keys
    end
  end

  test "#ups will throw an error if location info is invalid" do
    VCR.use_cassette("quote") do
      weight = 5
      origin = { country: 'US', state: 'WA', city: 'Seattle', zip: '98151' }
      destination = { country: 'US', state: 'XX', city: 'Los Angeles', zip: '1' }
      dimensions = [15, 10, 4.5]
      bad_quote = Quote.new(weight, origin, destination, dimensions)
      assert_raises (ActiveShipping::ResponseError) do
        bad_quote.ups
      end
      puts ActiveShipping::ResponseError
    end
  end

  test "calling #usps will return a hash of rates from USPS with different service names" do
    VCR.use_cassette("quote") do
    # keys = ["USPS Library Mail Parcel", "USPS Media Mail Parcel", "USPS Retail Ground", "USPS Priority Mail 1-Day", "USPS Priority Mail Express 2-Day", "USPS Priority Mail Express 2-Day Sunday/Holiday Delivery"]

      assert_instance_of Hash, @quote.usps
    # assert_equal 6, @quote.usps.length
    # assert_equal keys, @quote.usps.keys
    end
  end

end

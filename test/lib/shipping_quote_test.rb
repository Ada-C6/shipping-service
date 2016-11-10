require 'test_helper'

class ShippingQuoteTest < ActiveSupport::TestCase
  PETSY = {country: 'US',state: 'CA', city: 'Beverly Hills', zip: '90210'}
  ADA = {country: 'US',state: 'WA', city: 'Seattle', zip: '98101'}


  ### Tests for initializing ###
  test "should initialize a quote with the required arguments" do

    VCR.use_cassette("active_shipping") do
      package = ActiveShipping::Package.new(7.5 * 16,           # weight
      [12,12,12],         # dimensions
      units: :imperial)   # options
      origin = ActiveShipping::Location.new(PETSY)
      destination = ActiveShipping::Location.new(ADA)

      parcel = ShippingQuote.new(package, origin, destination)

      assert_instance_of ShippingQuote, parcel
    end
  end


  #test to handle bad data in arguments

  ### Parcel wrapping ###

  # carriers supported: UPS, USPS
  test "#requesting_quote(carrier) should return an instance of ShippingQuote from the different carriers" do

    VCR.use_cassette("active_shipping") do
      carrier = "ups"
      package = ActiveShipping::Package.new(7.5 * 16,           # weight
      [12,12,12],         # dimensions
      units: :imperial)   # options
      origin = ActiveShipping::Location.new(PETSY)
      destination = ActiveShipping::Location.new(ADA)
      parcel = ShippingQuote.new(package, origin, destination)
      quotes = parcel.requesting_quote(carrier) # array of arrays

      assert Array, quotes
      quotes.each do |quote|
        assert Array, quote
      end
    end
  end

  #Not implemented because the package, origin, destination will be send here from elsewhere in our API
  # test "#requesting_quote(carrier) accepts only arguments with the required data" do
  # end

  test "#requesting_quote will only return valid data from ups" do
    VCR.use_cassette("active_shipping") do
      carrier = "ups"
      package = ActiveShipping::Package.new(7.5 * 16,           # weight
      [12,12,12],         # dimensions
      units: :imperial)   # options
      origin = ActiveShipping::Location.new(PETSY)
      destination = ActiveShipping::Location.new(ADA)
      parcel = ShippingQuote.new(package, origin, destination)

      quotes = parcel.requesting_quote(carrier) # array of arrays

      assert_not_nil quotes

      quotes.each do |quote|
        assert String, quote[0]
        assert Integer, quote[1]
      end
    end
  end

  test "requesting_quote from unknown carrier will return nil" do
    VCR.use_cassette("active_shipping") do
      carrier = "Lucy's cargo"
      package = ActiveShipping::Package.new(7.5 * 16,           # weight
      [12,12,12],         # dimensions
      units: :imperial)   # options
      origin = ActiveShipping::Location.new(PETSY)
      destination = ActiveShipping::Location.new(ADA)
      parcel = ShippingQuote.new(package, origin, destination)

      nil_quotes = parcel.requesting_quote(carrier)

      assert_nil nil_quotes
    end
  end

  # for each of the carriers, except ups above, only one test
  test "#requesting_quote will only return valid data from usps" do
    VCR.use_cassette("active_shipping") do
      carrier = "usps"
      package = ActiveShipping::Package.new(7.5 * 16,           # weight
      [12,12,12],         # dimensions
      units: :imperial)   # options

      origin = ActiveShipping::Location.new(PETSY)
      destination = ActiveShipping::Location.new(ADA)

      parcel = ShippingQuote.new(package, origin, destination)


      quotes = parcel.requesting_quote(carrier) # array of arrays

      assert_not_nil quotes
      assert Array, quotes

      quotes.each do |quote|
        assert Array, quote
        assert String, quote[0]
        assert Integer, quote[1]
      end
    end
  end

  # test "#carrier_quotes should return supported carriers quotes as an array of length = 2 arrays" do
  #   VCR.use_cassette("active_shipping") do
  #     petsy_carriers = ["ups", "usps"] #the carriers approved by our customer (petsy)
  #     package = ActiveShipping::Package.new(7.5 * 16,           # weight
  #                                           [12,12,12],         # dimensions
  #                                           units: :imperial)   # options
  #     origin = ActiveShipping::Location.new(PETSY)
  #     destination = ActiveShipping::Location.new(ADA)
  #
  #     parcel = ShippingQuote.new(package, origin, destination)
  #
  #     quotes = parcel.carrier_quotes(petsy_carriers) # array of arrays
  #
  #     quotes.each do |quote|
  #       assert_instance_of Array, quote
  #       assert_equal 2, quote.length # not valid because we are also testing two carriers
  #
  #     end
  #   end
  # end

  #first implement a second carrier then @todo : ->

  # test "#carrier_quotes should return all the quotes from each carrier as an array of arrays" do
  #   VCR.use_cassette("active_shipping") do
  #     petsy_carriers = ["ups"] #the carriers approved by our customer (petsy)
  #     package = ActiveShipping::Package.new(7.5 * 16,           # weight
  #                                           [12,12,12],         # dimensions
  #                                           units: :imperial)   # options
  #
  #     origin = ActiveShipping::Location.new(PETSY)
  #     destination = ActiveShipping::Location.new(ADA)
  #
  #     parcel = ShippingQuote.new(package, origin, destination)
  #     quotes = parcel.carrier_quotes(petsy_carriers) # array of arrays
  #
  #     assert_equal 6, quotes.length
  #     #must implement a second carrier for this to work/fail
  #     quotes.each do |quote|
  #       assert Array, quote
  #     end
  #   end
  # end



end

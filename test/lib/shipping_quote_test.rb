require 'test_helper'

class ShippingQuoteTest < ActiveSupport::TestCase
  PETSY = {country: 'US',state: 'CA', city: 'Beverly Hills', zip: '90210'}
  ADA = {country: 'US',state: 'WA', city: 'Seattle', zip: '98101'}

  ### Tests for initializing ###
  test "should initilize a quote with the required arguments" do
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

  # carriers supported: UPS
  test "#request_quote(carrier) should return an instance of ShippingQuote from the different carriers" do
    VCR.use_cassette("active_shipping") do
      carrier = "ups"
      package = ActiveShipping::Package.new(7.5 * 16,           # weight
      [12,12,12],         # dimensions
      units: :imperial)   # options
      origin = ActiveShipping::Location.new(PETSY)
      destination = ActiveShipping::Location.new(ADA)

      parcel = ShippingQuote.new(package, origin, destination)

      quotes = parcel.requesting_quote(carrier)
      assert false

    end
  end

end

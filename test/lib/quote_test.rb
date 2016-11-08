require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  test "that tests are working" do
    assert true
  end

  test "should #initialize with weight, origin, destination, dimensions" do
    weight = 3
    origin = { country: 'US', state: 'WA', city: 'Seattle', zip: '98151' }
    destination = { country: 'US', state: 'CA', city: 'Los Angeles', zip: '90032' }
    dimensions = [15, 10, 4.5]
    q = Quote.new(weight, origin, destination, dimensions)
    # assert_equal
  end

  test "on #intialize should create new package, origin and destination with Active Shipping gem" do

  end

  test "calling .ups will return a hash of rates from UPS with different service names" do
    
  end

end

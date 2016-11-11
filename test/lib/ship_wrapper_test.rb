require 'test_helper'
require 'ship_wrapper'

class ShipWrapperTest < ActiveSupport::TestCase
  def setup
    @package = [ActiveShipping::Package.new(100, [10,10,10])]
    @buyer_location = ActiveShipping::Location.new(country: 'US',  state: 'CO', city: 'Erie', zip: '80516')
  end

  test "the truth" do
    assert true
  end

  test 'self.get_rates works with usps'  do
    rates = ShipWrapper.get_rates('usps', @package, @buyer_location)
    assert_instance_of Array, rates
    rates.each do |rate|
      assert_instance_of ActiveShipping::RateEstimate, rate
      # assert_instance_of String, rate[0]
      # assert_instance_of Fixnum, rate[1]
    end
  end

  test 'self.get_rates works with fedex'  do
    rates = ShipWrapper.get_rates('fedex', @package, @buyer_location)
    assert_instance_of Array, rates
    rates.each do |rate|
      assert_instance_of ActiveShipping::RateEstimate, rate
      # assert_instance_of String, rate[0]
      # assert_instance_of Fixnum, rate[1]
    end
  end

  test 'self.get_rates returns empty array if carrier != a carrier we support' do
    rates = ShipWrapper.get_rates('bloop', @package, @buyer_location)
    assert_instance_of Array, rates
    assert_empty(rates)
  end

end

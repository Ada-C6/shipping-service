require 'test_helper'

class RateTest < ActiveSupport::TestCase
  test "rate belongs a shipment" do
    rate = rates(:one)
    assert_equal rate.shipment_id, shipments(:one).id
  end

  
end

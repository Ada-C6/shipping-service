require 'test_helper'

class ShippingTest < ActiveSupport::TestCase
  fixtures :all
  # test "the truth" do
  #   assert true
  # end

  test "should create a destination" do
    destination_hash = shippings(:one).destination_hash
    portland = Shipping.new
    locale = portland.destination(destination_hash)
    assert_not_nil locale
  end
end

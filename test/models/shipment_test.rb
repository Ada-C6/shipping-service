require 'test_helper'

class ShipmentTest < ActiveSupport::TestCase
  test "a package will be created with valid weight, height, length, unit" do
    package = ActiveShipping::Package.new(7.5 * 16,[15, 10, 4.5], units: :imperial)
    assert_not_nil package
    assert_instance_of Shipment, package
  end
end

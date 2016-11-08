require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test "should have all required fields" do
    location = Location.new(country = "US", state = "California", city = "Los Angeles", zip = 90215)

    assert location.valid?
  end

  test "Not valid location should result in incomplete-based errors" do
    location = Location.new(country = nil, state = nil, city = nil, zip = nil)

    assert_not location.valid?
    assert_includes location.errors, :country
    assert_includes location.errors, :state
    assert_includes location.errors, :city
    assert_includes location.errors, :zip
  end
end

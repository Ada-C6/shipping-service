require 'test_helper'

class PackageTest < ActiveSupport::TestCase

  test "should have all required fields" do
    package = Package.new(weight = 15, length = 10, width = 10, height = 10)

    assert package.valid?
  end

  test "Not valid package should result in incomplete-based errors" do
    package = Package.new(weight = nil, length = nil, width = nil, height = nil)

    assert_not package.valid?
    assert_includes package.errors, :weight
    assert_includes package.errors, :length
    assert_includes package.errors, :width
    assert_includes package.errors, :height
  end

end

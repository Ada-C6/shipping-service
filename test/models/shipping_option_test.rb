require 'test_helper'

class ShippingOptionTest < ActiveSupport::TestCase
  test "ShippingOption must have a name and cost greater than 0" do
    positive_case = shipping_options(:one)
    negative_case = shipping_options(:two)

    assert positive_case.valid?
    assert_not negative_case.valid?
  end

  test "we can create a package given a positive weight" do
    weight = 10 #in pounds
    package = ShippingOption.package(weight)

    assert_instance_of ActiveShipping::Package, package
  end

  test "we return an error if package_weight is below zero" do
    assert_raises ArgumentError do
      weight = -10 #in pounds
      package = ShippingOption.package(weight)
    end

  end
end

require 'test_helper'

class ShippingOptionTest < ActiveSupport::TestCase
  test "ShippingOption must have a name and cost greater than 0" do
    positive_case = shipping_options(:one)
    negative_case = shipping_options(:two)

    assert positive_case.valid?
    assert_not negative_case.valid?
  end
end

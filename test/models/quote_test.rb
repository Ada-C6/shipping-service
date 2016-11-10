require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "create a quote with valid data" do
    quote = quotes(:one)
    assert quote.valid?
  end

  test "will not create a quote with invalid data" do
    quote1 = Quote.new(name: "Best Quote Test Quote", shipment_id: "2222")
    quote2 = Quote.new(name: "Best Quote Test Quote", shipment_id: "2222", price: "Five hundred")

    assert_not quote1.valid?
    assert_not quote2.valid?

  end

end

require 'test_helper'

class QuoteTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "create a quote with valid data" do
    quote = quotes(:one)
    assert quote.valid?
  end
end

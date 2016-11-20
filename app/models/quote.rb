class Quote < ActiveRecord::Base
  attr_reader :cost, :name

  def initialize(cost, name)
    @name = name
    @cost = cost
  end
end

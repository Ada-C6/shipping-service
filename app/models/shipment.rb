require 'active_shipping'
class Shipment < ActiveRecord::Base
  def initialize (package, location)
    @package = ActiveShipping::Package.new(weight, quantity)
    @location = location

  end
end

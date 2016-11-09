require 'active_shipping'

class Shipment
  attr_reader :package, :origin, :destination

  def initialize(shipment_info_hash)
    weight = shipment_info_hash[:weight] * 16 #we are assuming petsy will add all package weights for us
    dest_country = shipment_info_hash[:country]
    dest_state = shipment_info_hash[:state]
    dest_city = shipment_info_hash[:city]
    dest_zip = shipment_info_hash[:zip] #we are assuming this is coming in as a string

    @package = ActiveShipping::Package.new(weight, [15, 10, 4.5], units: :imperial)
    @origin = ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", zip: "98101")
    @destination = ActiveShipping::Location.new(country: dest_country, state: dest_state, city: dest_city, zip: dest_zip)
  end
end

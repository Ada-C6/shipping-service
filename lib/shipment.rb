require 'active_shipping'

class Shipment
    attr_reader :package, :origin, :destination, :dest_city

    USPS_LOGIN = '677JADED7283'
    UPS_LOGIN = 'shopifolk'
    UPS_KEY = '7CE85DED4C9D07AB'
    UPS_PASSWORD = 'Shopify_rocks'

    def initialize(shipment_info_hash)
        weight = shipment_info_hash[:weight] * 16 #we are assuming petsy will add all package weights for us, in lbs that we're converting to ounces
        dest_country = shipment_info_hash[:country]
        dest_state = shipment_info_hash[:state]
        @dest_city = shipment_info_hash[:city] #made this an accessible attribute for testing purposes
        dest_zip = shipment_info_hash[:zip] #we are assuming this is coming in as a string

        @package = ActiveShipping::Package.new(weight, [15, 10, 4.5], units: :imperial)
        @origin = ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", zip: "98101")
        @destination = ActiveShipping::Location.new(country: dest_country, state: dest_state, city: dest_city, zip: dest_zip)
    end

    def usps_quotes
        usps = ActiveShipping::USPS.new(login: USPS_LOGIN)
        response = usps.find_rates(@origin, @destination, @package)
        rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
        return rates
        # this comes back as an array of arrays with all USPS shipping option quotes
    end

    def ups_quotes
        ups = ActiveShipping::UPS.new(login: UPS_LOGIN, password: UPS_PASSWORD, key: UPS_KEY)
        response = ups.find_rates(@origin, @destination, @package)
        rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
        return rates
        # this comes back as an array of arrays with all UPS shipping option quotes
    end

    def all_quotes
        all = []
        all += ups_quotes + usps_quotes
        # this comes back as an array of arrays, first with all UPS shipping option quotes, followed by all USPS shipping option quotes.
    end
end

# this was used during our development, could delete at this point...

# shipment_info_hash = {weight: 15, country: 'US', state: 'OH', city: 'Akron', zip: '44333' }
# a = Shipment.new(shipment_info_hash)
#
# puts a.origin
# puts a.destination
# puts a.package.to_s
# ups = a.ups_quotes
# puts ups
# usps = a.usps_quotes
# puts usps

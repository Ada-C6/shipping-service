require 'active_shipping'


class Quote
    attr_reader :usps_options, :ups_options


    def initialize(shipment_info_hash)
        @shipment = Shipment.new(shipment_info_hash)
    end

    def usps_options
        usps_rates
    end

    def ups_options
        ups_rates
    end


    private
    def usps_rates
        usps = ActiveShipping::USPS.new(login: ENV['USPS_LOGIN'])
        response = usps.find_rates(@shipment.origin, @shipment.destination, @shipment.package)
        rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
        return rates
        # this comes back as an array of arrays with all USPS shipping option quotes
    end

    def ups_rates
        ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
        response = ups.find_rates(@shipment.origin, @shipment.destination, @shipment.package)
        rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
        return rates
        # this comes back as an array of arrays with all UPS shipping option quotes
    end
end




shipment_info_hash = {weight: 15, country: 'US', state: 'OH', city: 'Akron', zip: '44333' }
a = Quote.new(shipment_info_hash)
puts a.usps_options
puts a.ups_options

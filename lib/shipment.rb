require 'active_shipping'

class Shipment
  def self.origin
    ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", postal_code: "98161")
  end

  # destination_hash = {country: "US", state :"XX", city: "Zxxxx", zip: "00000"}
  def self.destination(destination_hash)
    ActiveShipping::Location.new(destination_hash)
  end

  def self.package(weight, length, width, height)
    ActiveShipping::Package.new(weight * 16, [length, width, height], units: :imperial)
  end

  def self.condense_list (carrier, options)
    carrier_rates = []
    options.each do | option |
      option_info = {}
      option_info[:carrier] = option.carrier
      option_info[:service_name] = option.service_name
      option_info[:total_price] = option.total_price
      carrier_rates << option_info
    end
    return carrier_rates
  end

  def self.ups_rates(origin, destination, package)
    ups = ActiveShipping::UPS.new(login: ENV['ACTIVESHIPPING_UPS_LOGIN'], password: ENV['ACTIVESHIPPING_UPS_PASSWORD'], key: ENV['ACTIVESHIPPING_UPS_KEY'])
    response = ups.find_rates(origin, destination, package)
    options = response.rates.sort_by(&:price)
    ups_rates = condense_list(ups, options)

    return ups_rates
  end

  def self.usps_rates(origin, destination, package)
    usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])
    response = usps.find_rates(origin, destination, package)
    options = response.rates.sort_by(&:price)
    usps_rates = condense_list(usps, options)

    return usps_rates
  end

  # def fedex_rates
  #   fedex = FedEx.new(login: "your fedex login", password: "your fedex password", key: "your fedex key", account: "your fedex account number")
  #   get_rates_from_shipper(fedex)
  # end
end

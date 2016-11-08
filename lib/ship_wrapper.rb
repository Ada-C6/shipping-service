require 'httparty'
require 'uri'
require 'active_shipping'

class ShipWrapper

  ORIGIN =  ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98119')
  USPS_LOGIN = ENV["UPS_USERNAME"]

  def self.get_rates(carrier, package, destination)
    case carrier.downcase
    when 'usps'
      usps = ActiveShipping::USPS.new(login: USPS_LOGIN)
      response = usps.find_rates(ORIGIN, destination, package)
      usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    when 'fedex'
    when 'ups'
    else
      "blah blah"
    end
  end

  def self.make_package(weight, array_of_heights)
    package = ActiveShipping::Package.new(weight, array_of_heights, units: :imperial)
    return package
  end

  def self.make_destination(country, state, city, zip)
    destination = ActiveShipping::Location.new(country: country, state: state, city: city, zip: zip)
    return destination
  end

end

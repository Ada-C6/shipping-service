require 'active_shipping'

class ShipWrapper

  ORIGIN =  ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98119')
  USPS_LOGIN = ENV["USPS_USERNAME"]

  def self.get_rates(carrier, package, destination)
    case carrier.downcase
    when 'usps'
      usps = ActiveShipping::USPS.new(login: USPS_LOGIN)
      response = usps.find_rates(ORIGIN, destination, package)
      rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    when 'fedex'
      # this will be populated later. right now we are just trying with one single carrier.
    when 'ups'
      # same as above
    else
      rates = []
    end
    return rates #=> [["usps blah blah", 3404], ["usps overnight", 49383]]
  end


# this should go in the controller
  # def self.make_package(weight, array_of_dimensions)
  #   package = ActiveShipping::Package.new(weight, array_of_dimensions, units: :imperial)
  #   return package
  # end
  #
  # def self.make_destination(country, state, city, zip)
  #   destination = ActiveShipping::Location.new(country: country, state: state, city: city, zip: zip)
  #   return destination
  # end

end

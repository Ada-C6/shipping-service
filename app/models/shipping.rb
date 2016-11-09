  require 'active_shipping'

class Shipping < ActiveRecord::Base
  # attr_reader :
ORIGIN = ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98122')


# destination_hash comes from petsy ex: {country: '', state: '', city: '', zip: ''}
def self.destination(country, state, city, zip)
  address = {country: "#{country}", state: "#{state}", city: "#{city}", zip: "#{zip}"}
  ActiveShipping::Location.new(address)
end

# create_packages will create objects and take array of weights ex: [12, 35, 5]
def self.create_packages(weights_string)
  packages = []
  weights_array = weights_string.split(",").map(&:to_i)
  weights_array.each do |item|
    packages << ActiveShipping::Package.new(item * 16, [15, 10, 4.5], units: :imperial)
  end
  return packages
end




#def ups(destination, weight)

  # ups = ActiveShipping::UPS.new(
  #   login: ENV[ACTIVESHIPPING_UPS_LOGIN],
  #   password: ENV[ACTIVESHIPPING_UPS_PASSWORD], key: ENV[ACTIVESHIPPING_UPS_KEY])

  # response = ups.find_rates(origin, destination, packages)

  # ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

#end

# def usps
#
#  usps = ActiveShipping::USPS.new(login: ENV[ACTIVESHIPPING_USPS_LOGIN])
#
#  response = usps.find_rates(origin, destination, packages)
#
#  usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
#
#  end

end

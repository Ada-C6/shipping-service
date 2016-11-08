  require 'active_shipping'

class Shipping < ActiveRecord::Base

#def ups(parameters)

  ups = ActiveShipping::UPS.new(
    login: ENV[ACTIVESHIPPING_UPS_LOGIN],
    password: ENV[ACTIVESHIPPING_UPS_PASSWORD], key: ENV[ACTIVESHIPPING_UPS_KEY])

  response = ups.find_rates(origin, destination, packages)

  ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

#end

def usps

 usps = ActiveShipping::USPS.new(login: ENV[ACTIVESHIPPING_USPS_LOGIN])

 response = usps.find_rates(origin, destination, packages)

 usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

 end

end

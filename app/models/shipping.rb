  require 'active_shipping'

class Shipping < ActiveRecord::Base
    # attr_reader :
  ORIGIN = ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98122')


  # destination_hash comes from petsy ex: {country: '', state: '', city: '', zip: ''}
  def destination(country, state, city, zip)
    address = {country: "#{country}", state: "#{state}", city: "#{city}", zip: "#{zip}"}
    ActiveShipping::Location.new(address)
  end

  # create_packages will create objects and take string of weights ex: [12, 35, 5]
  def create_packages(weights_string)
    packages = []
    weights_array = weights_string.split(",").map(&:to_i)
    weights_array.each do |item|
      packages << ActiveShipping::Package.new(item * 16, [15, 10, 4.5], units: :imperial)
    end
    return packages
  end


  def ups(origin, destination, packages)

  ups = ActiveShipping::UPS.new(
       login: "shopifolk",
       password: "Shopify_rocks", key: "7CE85DED4C9D07AB")

   response = ups.find_rates(origin, destination, packages)

     ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return ups_rates
  end


  def usps(origin, destination, packages)
    developer_key = "677JADED7283"
    usps = ActiveShipping::USPS.new(login: developer_key)
    response = usps.find_rates(origin, destination, packages)
    usps_rates = response.rates.sort_by(&:price).collect {|rate|
       [rate.service_name, rate.price]}
    return usps_rates
  end

  def shipping_options

    package_destination = a.destination(a.country, a.state, a.city, a.zip)

    collected_packages = a.create_packages(a.weights)

    usps_rates = a.usps(origin, package_destination, collected_packages)
    # => will return an array of arrays

    ups_rates = a.ups.(origin, package_destination, collected_packages)
    # => returns
    returns ">>>>>>>>>>>#{usps_rates} + #{ups_rates}"
  end
end

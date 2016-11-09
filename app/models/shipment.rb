class Shipment < ActiveRecord::Base

  def get_destination
    return ActiveShipping::Location.new(country: self.country, city: self.city, zip: self.zip)
  end

  def get_origin
    return ActiveShipping::Location.new(country: "US", city: "Seattle", zip: 98116)
  end

  def get_package
    return ActiveShipping::Package.new(self.weight, [self.length, self.width, self.height], units: :imperial)
  end

  def ups_rates
    ups = ActiveShipping::UPS.new(login: ENV["ACTIVESHIPPING_UPS_LOGIN"], password: ENV["ACTIVESHIPPING_UPS_PASSWORD"], key: ENV["ACTIVESHIPPING_UPS_KEY"])
    dest = get_destination
    pack = []
    pack << get_package
    origin = get_origin

    response = ups.find_rates(origin, dest, pack)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return ups_rates
  end

  # def usps_rates
  #   ups = ActiveShipping::USPS.new(login: ENV["ACTIVESHIPPING_USPS_LOGIN"])
  #   response = usps.find_rates(origin, destination, packages)
  #   usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  #   return ups_rates
  # end
end

# TODO: Make Rates model which belongs-to Shipment. This will store all the rates, so later Petsy can go find that rate. Somehow.

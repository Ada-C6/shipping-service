# require 'active_shipping'

class Shipment < ActiveRecord::Base
  validates :weight, presence: true
  validates :height, presence: true
  validates :length, presence: true
  validates :width, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :zipcode, presence: true
  validates :units, presence: true

  USPS_LOGIN = ENV["USPS_LOGIN"]
  UPS_LOGIN = ENV["UPS_LOGIN"]
  UPS_PASSWORD = ENV["UPS_PASSWORD"]
  UPS_KEY = ENV["UPS_KEY"]

  # package information
  def weight_conversion(weight)
    if units == "metric"
      weight
    elsif units == "imperial"
      weight = weight * 16
    end
  end

  def package
    return ActiveShipping::Package.new(weight_conversion(weight), [length, width, height], units: :units)
  end

  def origin
    # Normally this wouldn't be hardcoded, but the limitations of the
    # project necessitate it.
    return ActiveShipping::Location.new(country: "United States", state: "WA", city: "Seattle", postal_code: "98161")
  end


  #This method works for both origin and destination
  def destination
    return ActiveShipping::Location.new(country: country, state: state, city: city, postal_code: zipcode)
  end

  # Calling UPS and USPS...
  # response = ups.find_rates(origin, destination, packages)
  def ups_rates
    ups = ActiveShipping::UPS.new(login: UPS_LOGIN, password: UPS_PASSWORD, key: UPS_KEY)
    response = ups.find_rates(origin, destination, package)
    return response.rates
  end

  def usps_rates
    usps = ActiveShipping::USPS.new(login: USPS_LOGIN)
    response = usps.find_rates(origin, destination, package)
    return response.rates
  end
end

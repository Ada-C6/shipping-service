require 'active_shipping'

class Shipment
#do we use validations for lib classes????
  # validates :name, presence: true
  # validates :country, presence: true
  # validates :city, presence: true
  # validates :state, presence: true
  # validates :postal_code, presence: true
  # validates :length, presence: true
  # validates :width, presence: true
  # validates :height, presence: true
  # validates :weight, presence: true


  def self.origin
    ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", postal_code: 98161)
  end

  # destination_hash = {country: "US", state :"XX", city: "Zxxxx", zip: "00000"}
  def self.destination(destination_hash)
    ActiveShipping::Location.new(destination_hash)
  end

  def self.package(weight, length, width, height)
    ActiveShipping::Package.new(weight * 16, [length, width, height], units: :imperial)
  end

  def self.ups_rates(origin, destination, package)
    ups = ActiveShipping::UPS.new(login: ENV['ACTIVESHIPPING_UPS_LOGIN'], password: ENV['ACTIVESHIPPING_UPS_PASSWORD'], key: ENV['ACTIVESHIPPING_UPS_KEY'])
    response = ups.find_rates(origin, destination, package)
    response.rates.sort_by(&:price)
  end

  def self.usps_rates(origin, destination, package)
    usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])
    response = usps.find_rates(origin, destination, package)
    response.rates.sort_by(&:price)
  end

  # def fedex_rates
  #   fedex = FedEx.new(login: "your fedex login", password: "your fedex password", key: "your fedex key", account: "your fedex account number")
  #   get_rates_from_shipper(fedex)
  # end
end

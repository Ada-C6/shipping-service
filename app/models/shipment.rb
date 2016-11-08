require 'active_shipping'
class Shipment < ActiveRecord::Base

  # validates :name, presence: true
  # validates :country, presence: true
  # validates :city, presence: true
  # validates :state, presence: true
  # validates :postal_code, presence: true
  # validates :length, presence: true
  # validates :width, presence: true
  # validates :height, presence: true
  # validates :weight, presence: true


  def origin
    Location.new(country: "US", state: "WA", city: "Seattle", postal_code: "98161")
  end

  # destination_hash
  # {country: "US"
  # state :"XX"
  # city: "Zxxxx"
  # zip: "00000"}
  def destination(destination_hash)
    Location.new(destination_hash)
  end

  # (weight * 16, dimensions = [length x width x height], units: :imperial)
  def packages(weight, dimensions)
    Package.new(weight * 16, dimensions, units: :imperial)
  end

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price)
  end

  def ups_rates
    ups = UPS.new(login: ENV['ACTIVESHIPPING_UPS_LOGIN'], password: ENV['ACTIVESHIPPING_UPS_PASSWORD'], key: ENV['ACTIVESHIPPING_UPS_KEY'])
    get_rates_from_shipper(ups)
  end

  # def fedex_rates
  #   fedex = FedEx.new(login: "your fedex login", password: "your fedex password", key: "your fedex key", account: "your fedex account number")
  #   get_rates_from_shipper(fedex)
  # end

  # def usps_rates
  #   usps = USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'], password: 'your usps password')
  #   get_rates_from_shipper(usps)
  # end
end

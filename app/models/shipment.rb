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


  def self.origin
    ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", postal_code: "98161")
  end

  # destination_hash
  # {country: "US"
  # state :"XX"
  # city: "Zxxxx"
  # zip: "00000"}
  def self.destination(destination_hash)
    ActiveShipping::Location.new(destination_hash)
  end

  def self.package(weight, length, width, height)
    ActiveShipping::Package.new(weight * 16, [length, width, height], units: :imperial)
  end

  def self.get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price)
  end

  def self.ups_rates
    ups = ActiveShipping::UPS.new(login: ENV['ACTIVESHIPPING_UPS_LOGIN'], password: ENV['ACTIVESHIPPING_UPS_PASSWORD'], key: ENV['ACTIVESHIPPING_UPS_KEY'])
    get_rates_from_shipper(ups)
  end

  # def fedex_rates
  #   fedex = FedEx.new(login: "your fedex login", password: "your fedex password", key: "your fedex key", account: "your fedex account number")
  #   get_rates_from_shipper(fedex)
  # end

  def self.usps_rates
    usps = USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])
    get_rates_from_shipper(usps)
  end
end

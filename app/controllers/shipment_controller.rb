require 'active_shipping'

class ShipmentController < ApplicationController
  before_action: :origin, :destination, :packages, :get_rates_from_shipper, :ups_rates, :fedex_rates, :usps_rates

  def index

  end

  def show

  end

  private

  # def shipment_params
  # end

  def origin
    Location.new(country: "US", state: "WA", city: "Seattle", zip: "98161")
  end

  def destination
    Location.new(params[:country], params[:state], params[:city], params[:zip])
  end

  def packages
    package = Package.new(params[:weight], [length, width, height])
  end

  def get_rates_from_shipper(shipper)
    response = shipper.find_rates(origin, destination, packages)
    response.rates.sort_by(&:price) #might be total_price
  end

  def ups_rates
    ups = UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PW'], key: ENV['UPS_KEY')
    get_rates_from_shipper(ups)
  end

  def fedex_rates
    fedex = FedEx.new(login: ENV['FEDEX_METER_NO'], password: ENV['FEDEX_PW'], account: ENV['FEDEX_ACCT'], test: true)
    get_rates_from_shipper(fedex)
  end

  def usps_rates
    usps = USPS.new(login: ENV['USPS_LOGIN'])
    get_rates_from_shipper(usps)
  end
end

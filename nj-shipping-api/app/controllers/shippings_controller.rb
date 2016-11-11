require 'active_shipping'

class ShippingsController < ApplicationController

  def index
    @package = {weight: 100, size: [50, 50, 50]}
    @origin = {country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210'}
    @destination = {country: 'US', state: 'WA', city: 'Seattle', zip: '98102'}

    packages = [ActiveShipping::Package.new(@package[:weight], @package[:size])]
    origin = ActiveShipping::Location.new(country: @origin[:country], state: @origin[:state], city: @origin[:city], zip: @origin[:zip])
    destination = ActiveShipping::Location.new(country: @destination[:country], state: @destination[:state], city: @destination[:city], zip: @destination[:zip])

    ups = ActiveShipping::UPS.new(login: ENV["UPS_ID"].to_s, password: ENV["UPS_PW"], key: ENV["UPS_KEY"])
    ActiveShipping::UPS.logger = Logger.new('log/shipping.txt')
    usps = ActiveShipping::USPS.new(login: ENV["USPS_ID"])
    ActiveShipping::USPS.logger = Logger.new('log/shipping.txt')
    fedex = ActiveShipping::FedEx.new(login: ENV["FEDEX_LOGIN"], password: ENV["FEDEX_PW"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACCOUNT"], test: true)
    ActiveShipping::FedEx.logger = Logger.new('log/shipping.txt')

    begin
      ups_response = ups.find_rates(origin, destination, packages)
    rescue ActiveShipping::ResponseError
      ups_response = nil
    end

    begin
      usps_response = usps.find_rates(origin, destination, packages)
    rescue ActiveShipping::ResponseError
      usps_response = nil
    end

    begin
      fedex_response = fedex.find_rates(origin, destination, packages)
    rescue ActiveShipping::ResponseError
      fedex_response = nil
    end

    if ups_response && usps_response && fedex_response
      rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]} + usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]} + fedex_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    end

    if rates
      render :json => rates, :status => :ok
    else
      render :json => [], :status => :no_content
    end

  end

  def show
    @provider = params[:carrier_name].downcase
    @package = {weight: 100, size: [50, 50, 50]}
    @origin = {country: 'US', state: 'CA', city: 'Beverly Hills', zip: '90210'}
    @destination = {country: 'US', state: 'WA', city: 'Seattle', zip: '98102'}

    packages = [ActiveShipping::Package.new(@package[:weight], @package[:size])]
    origin = ActiveShipping::Location.new(country: @origin[:country], state: @origin[:state], city: @origin[:city], zip: @origin[:zip])
    destination = ActiveShipping::Location.new(country: @destination[:country], state: @destination[:state], city: @destination[:city], zip: @destination[:zip])

    case @provider
    when "ups"
      carrier = ActiveShipping::UPS.new(login: ENV["UPS_ID"].to_s, password: ENV["UPS_PW"], key: ENV["UPS_KEY"])
    when "usps"
      carrier = ActiveShipping::USPS.new(login: ENV["USPS_ID"])
    when "fedex"
      carrier = ActiveShipping::FedEx.new(login: ENV["FEDEX_LOGIN"], password: ENV["FEDEX_PW"], key: ENV["FEDEX_KEY"], account: ENV["FEDEX_ACCOUNT"], test: true)
    else
      carrier = nil
    end

    if carrier
      carrier_response = carrier.find_rates(origin, destination, packages)
      rates = carrier_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    end

    if rates
      render :json => rates, :status => :ok
    else
      render :json => [], :status => :no_content
    end

  end

end

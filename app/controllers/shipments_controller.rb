class ShipmentsController < ApplicationController

  def index
    package = ActiveShipping::Package.new(params[:weight].to_f*16, [12,12,12], units: :imperial)
    sender = ActiveShipping::Location.new(country: 'US', zip: params[:origin_zip].to_i)
    receiver = ActiveShipping::Location.new(country: 'US', zip: params[:destination_zip].to_i)

    results_hash = {}

    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
    ups_response = ups.find_rates(sender, receiver, package)
    ups_response_trimmed = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}

    results_hash["UPS"] = ups_response_trimmed

    usps = ActiveShipping::USPS.new(login: ENV['USPS_LOGIN'])
    usps_response = usps.find_rates(sender, receiver, package)
    usps_response_trimmed = usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}

    results_hash["USPS"] = usps_response_trimmed

    fedex = ActiveShipping::FedEx.new(login: ENV['FEDEX_LOGIN'], password: ENV['FEDEX_PASSWORD'], key: ENV['FEDEX_KEY'], account: ENV['FEDEX_ACCOUNT'], test: true)
    fedex_response = fedex.find_rates(sender, receiver, package)
    fedex_response_trimmed = fedex_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}

    results_hash["Fedex"] = fedex_response_trimmed

    render :json => results_hash, :status => :ok
  end

  def show
  end

end

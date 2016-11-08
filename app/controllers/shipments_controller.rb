class ShipmentsController < ApplicationController

  def index
    package = ActiveShipping::Package.new(params[:weight].to_f*16, [12,12,12], units: :imperial)
    sender = ActiveShipping::Location.new(country: 'US', zip: params[:origin_zip].to_i)
    receiver = ActiveShipping::Location.new(country: 'US', zip: params[:destination_zip].to_i)
    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
    response = ups.find_rates(sender, receiver, package)
    render :json => response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}, :status => :ok
  end

  def show
  end

end

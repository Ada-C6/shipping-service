class ShipmentsController < ApplicationController
  def index
    # test_params = {
    #   weight: 3.5,
    #   # dimensions: [15, 10, 4.5],
    #   length: 15,
    #   width: 10,
    #   height: 4.5,
    #
    #   country: "US",
    #   state: "CA",
    #   city: "Los Angeles",
    #   postal_code: "90078"
    # }
    #
    # package_weight = test_params[:weight].to_f
    # length = test_params[:length].to_f
    # width = test_params[:width].to_f
    # height =test_params[:height].to_f
    #
    # destination_hash = {
    #   country: test_params[:country],
    #   state: test_params[:state],
    #   city: test_params[:city],
    #   postal_code: test_params[:postal_code],
    # }

    package_weight = params[:weight].to_f
    length = params[:length].to_f
    width = params[:width].to_f
    height =params[:height].to_f

    destination_hash = {
      country: params[:country],
      state: params[:state],
      city: params[:city],
      postal_code: params[:billing_zip]
    }

    package = Shipment.package(package_weight, length, width, height)
    origin = Shipment.origin
    destination = Shipment.destination(destination_hash)

    ups = Shipment.ups_rates(origin, destination, package)
    usps = Shipment.usps_rates(origin, destination, package)

    ups_rates = []
    ups.each do | option |
      option_info = {}
      option_info[:carrier] = option.carrier
      option_info[:service_name] = option.service_name
      option_info[:total_price] = option.total_price
      ups_rates << option_info
    end

    usps_rates = []
    usps.each do | option |
      option_info = {}
      option_info[:carrier] = option.carrier
      option_info[:service_name] = option.service_name
      option_info[:total_price] = option.total_price
      usps_rates << option_info
    end

    all_shipping_options = {ups_rates: ups_rates, usps_rates: usps_rates}


    render json: all_shipping_options

  end

  # def show
  #do search for a particular order for a particular request. ie, when a customer selects one shipping option that they want
  # end
end

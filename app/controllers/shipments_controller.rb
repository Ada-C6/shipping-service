class ShipmentsController < ApplicationController
  def index
    test_params = {
      weight: 3.5,
      # dimensions: [15, 10, 4.5],
      length: 15,
      width: 10,
      height: 4.5,

      country: "US",
      state: "CA",
      city: "Los Angeles",
      postal_code: "90078"
    }

    package_weight = test_params[:weight].to_f
    length = test_params[:length].to_f
    width = test_params[:width].to_f
    height =test_params[:height].to_f

    destination_hash = {
      country: test_params[:country],
      state: test_params[:state],
      city: test_params[:city],
      postal_code: test_params[:postal_code],
    }

    # package_weight = params[:weight].to_f
    # length = params[:length].to_f
    # width = params[:width].to_f
    # height =params[:height].to_f
    #
    # destination_hash = {
    #   country: params[:country],
    #   state: params[:state],
    #   city: params[:city],
    #   postal_code: params[:postal_code],
    # }

    package = Shipment.package(package_weight, length, width, height)
    origin = Shipment.origin
    destination = Shipment.destination(destination_hash)

    ups_rates = Shipment.ups_rates(origin, destination, package)
    usps_rates = Shipment.usps_rates(origin, destination, package)

    all_shipping_options = {ups_rates: ups_rates, usps_rates: usps_rates}
    # all_shipping_options = ups_rates
    render json: all_shipping_options
  end

  def create
    package_weight = params[:weight].to_f
    length = params[:length].to_f
    width = params[:width].to_f
    height =params[:height].to_f

    destination_hash = {
      country: params[:country],
      state: params[:state],
      city: params[:city],
      postal_code: params[:postal_code],
    }

    @package = Shipment.package(package_weight, length, width, height)
    @origin = Shipment.origin
    @destination = Shipment.destination(destination_hash)

    @ups_rates = Shipment.ups_rates(@origin, @destination, @package)
    @usps_rates = Shipment.usps_rates(@origin, @destination, @package)
  end
end

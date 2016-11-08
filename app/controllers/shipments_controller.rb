class ShipmentsController < ApplicationController
  def index
    all_shipping_options = Shipment.all
    render json: all_shipping_options
  end

  def create
    package_weight = params[:weight]
    package_dimensions = params[:dimensions]

    destination_hash = {
      country: params[:country],
      state: params[:state],
      city: params[:city],
      postal_code: params[:postal_code],
    }

    @package = Shipment.package(package_weight,package_dimensions)
    @origin = Shipment.origin
    @destination = Shipment.destination(destination_hash)
  end
end

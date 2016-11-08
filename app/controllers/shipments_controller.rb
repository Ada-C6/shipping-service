class ShipmentsController < ApplicationController
  def index
    all_shipping_options = Shipment.all
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
  end
end

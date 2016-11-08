class ShipmentsController < ApplicationController
  def index
    all_shipping_options = Shipment.new(package, location)
    raise
    render json: all_shipping_options
  end
end

class ShipmentsController < ApplicationController
  def index
    # a collection of Shipment objects, can be anything.
    shipments = [] # just a placeholder
    render json: shipments
  end

end

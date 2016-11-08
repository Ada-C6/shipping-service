class ShipmentsController < ApplicationController

  def index
    ship = Shipment.all
    render json: ship
  end
end

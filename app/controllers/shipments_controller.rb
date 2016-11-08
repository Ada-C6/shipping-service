class ShipmentsController < ApplicationController
  def index
    shipments = []
    render json: shipments
  end

end

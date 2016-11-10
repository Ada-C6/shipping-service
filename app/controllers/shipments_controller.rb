class ShipmentsController < ApplicationController

  def create
    logger.info(">>>>>>>> #{request.body.read}")
    logger.info(">>>>>>>> #{params}")
    shipment = Shipment.new(shipment_params)
    if shipment.save
      render json: { "id": shipment.id }, status: :created
    else
      render status: 400
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:weight, :height, :length, :width, :city, :state, :country, :zipcode, :units)
  end
end

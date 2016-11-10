class ShipmentsController < ApplicationController

  def create
    logger.info(">>>>>>>> #{request.body.read}")
    logger.info(">>>>>>>> #{params}")
    shipment = Shipment.new(shipment_params)
    if shipment.save
      render json: { "id": shipment.id }, status: :created
    else
      # status 400: bad request
      render status: :bad_request, nothing: true
    end
  end

  private

  def shipment_params
    params.require(:shipment).permit(:weight, :height, :length, :width, :city, :state, :country, :zipcode, :units)
  end
end

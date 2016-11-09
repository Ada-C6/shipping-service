class ShipmentsController < ApplicationController
  # def index
  #   s = Shipment.create(params)
  #   s.ups_rates
  #   s.usps_rates
  #   results = s.rates
  #   render json: results
  # end

  def create
    logger.info(">>>>>>>> #{request.body.read}")
    logger.info(">>>>>>>> #{params}")
    shipment = Shipment.new(shipment_params)
    shipment.save
    render json: { "id": shipment.id }, status: :created
  end

  private

  def shipment_params
    params.require(:shipment).permit(:weight, :height, :length, :width, :city, :state, :country, :zipcode, :units)
  end
end

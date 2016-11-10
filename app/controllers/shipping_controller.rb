class ShippingController < ApplicationController

  def index
    shippings = Shipping.new
    render json: shippings
  end

  def create
    logger.info(">>>>>>>>> MEM: #{request.body.read}")
    logger.info(">>>>>>>>> MEM: #{params}")
    shipping = Shipping.new(shipment_params)
    shipping.save
    render json: { "id": shipping.id }, status: :created
  end

  private

    def shipment_params
      params.require(:shipping).permit(:city, :state, :zip, :country, :weights)
    end

end

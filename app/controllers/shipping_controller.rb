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

    shipping_destination = shipping.destination(shipping.country, shipping.state, shipping.city, shipping.zip)

    shipping_packages = shipping.create_packages(shipping.weights)

    shipping_rates = shipping.ups

    render json: { "id": shipping.id, "shipping_rates": shipping_rates }, status: :created
  end

  private

    def shipment_params
      params.require(:shipping).permit(:city, :state, :zip, :country, :weights)
    end

end

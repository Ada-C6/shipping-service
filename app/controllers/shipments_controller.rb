require 'timeout'
class ShipmentsController < ApplicationController

  def create
    logger.info "#{params}"

    status = Timeout::timeout(10) {
  # Something that should be interrupted if it takes more than 5 seconds...

      shipment = Shipment.new(params[:shipment][:origin], params[:shipment][:destination], params[:shipment][:packages])

      ups_rates = Shipment.ups(shipment.origin, shipment.destination, shipment.packages)

      usps_rates = Shipment.usps(shipment.origin, shipment.destination, shipment.packages)

      render json: {"ups": ups_rates, "usps": usps_rates}, status: :created }

    if status == false
      redirect_to :timeout
    end

  end
  #private

  # def shipment_params
  #   params.require(:shipment).permit(:origin, :destination, :packages)
  # end
end

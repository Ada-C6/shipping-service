class ShipmentsController < ApplicationController
  def index
    logger.info("#{request.body.read}")
    logger.info("#{params}")

    package_weight = params[:weight].to_f
    length = params[:length].to_f
    width = params[:width].to_f
    height =params[:height].to_f

    destination_hash = {
      country: params[:country],
      state: params[:state],
      city: params[:city],
      postal_code: params[:billing_zip]
    }

    package = Shipment.package(package_weight, length, width, height)
    origin = Shipment.origin
    destination = Shipment.destination(destination_hash)

    begin
      ups_rates = Shipment.ups_rates(origin, destination, package)
    rescue ActiveShipping::ResponseError
      render json: {}, status: :not_found and return
    end

    begin
      usps_rates = Shipment.usps_rates(origin, destination, package)
    rescue ActiveShipping::ResponseError
      render json: {}, status: :not_found and return
    end

    all_shipping_options = {ups_rates: ups_rates, usps_rates: usps_rates}

    render json: all_shipping_options#, only: [:carrier, :service_name, :total_price], status: :ok
  end

  # def show
  #do search for a particular order for a particular request. ie, when a customer selects one shipping option that they want
  # end

  # private
  ### we wanted an initialize method for shipment which would have used this
  # def shipment_params
  #   params.require(:shipment).permit(:weight, :length, :width, :height, :country, :state, :city,
  #   :billing_zip)
  # end
end

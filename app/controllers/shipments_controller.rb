class ShipmentsController < ApplicationController
  def index
    all_shipping_options = Shipment.all
    render json: all_shipping_options
  end

  def create
    @package = ActiveShipping::Package.new(weight * 16, dimensions, units: :imperial)

    # {country: "US"
    # state :"XX"
    # city: "Zxxxx"
    # zip: "00000"}
    @origin = ActiveShipping::Location.new(hash[:origin])
    @destination = ActiveShipping::Location.new(hash[:destination])

  end
end

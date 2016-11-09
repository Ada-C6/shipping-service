class ShipmentsController < ApplicationController

  def index
    ship = Shipment.new(city: params[:city], zip: params[:zip], weight: params[:weight])
    return_data = ship.generate_quotes
    # binding.pry
    render json: return_data
  end

  # def search
  # end
end

class ShipmentsController < ApplicationController

  def index
    ship = Shipment.new(city: params[:city], zip: params[:zip], weight: params[:weight])
    ship.save
    return_data = ship.generate_quotes
    render json: return_data
  end

  # TODO:
  def show
    quote = Quote.find_by_id(params[:id])
    if quote
      render json: Quote.find(params[:id])#, :except => [:created_at, :updated_at]
    else
      render :status => :no_content, json: {}
    end
  end
end

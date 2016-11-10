class ShipmentsController < ApplicationController

  def index
    logger.info(">>>>>>>TEAM_OF_AWESOME: #{params}")
    ship = Shipment.new(city: params[:city], zip: params[:zip], weight: params[:weight])
    ship.save
    return_data = ship.generate_quotes
    render json: return_data
  end


  def show
    logger.info(">>>>>>>TEAM_OF_AWESOME: #{params}")
    quote = Quote.find_by_id(params[:id])
    if quote
      render json: Quote.find(params[:id])
    else
      render :status => :no_content, json: {}
    end
  end
end

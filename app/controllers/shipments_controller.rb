class ShipmentsController < ApplicationController

  def index
    render :json => ShippingRateGetter.get_rates(params[:weight].to_f, params[:origin_zip].to_i, params[:destination_zip].to_i), :status => :ok
  end

  def show
  end

end

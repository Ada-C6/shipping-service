class ShipmentsController < ApplicationController

  def index
    begin
      render :json => ShippingRateGetter.get_rates(params[:weight].to_f, params[:origin_zip].to_i, params[:destination_zip].to_i), :status => :ok
    rescue ActiveShipping::ResponseError => e
      render :json => {error: "THERE WAS AN ISSUE. HIGHLY QUESTIONABLE."}, :status => '404'
    end
  end

  def show
  end

end

# e.response.params["Response"]["Error"].first["ErrorDescription"]

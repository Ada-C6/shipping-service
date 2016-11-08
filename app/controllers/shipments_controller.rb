require 'timeout'

class ShipmentsController < ApplicationController

  def index
    begin
      status = Timeout::timeout(10){
        render :json => ShippingRateGetter.get_rates(params[:weight].to_f, params[:origin_zip].to_i, params[:destination_zip].to_i), :status => :ok
      }
    rescue ActiveShipping::ResponseError => e
      render :json => {error: "THERE WAS AN ISSUE. HIGHLY QUESTIONABLE."}, :status => '404'
    rescue Timeout::Error
      render :json => {error: "THIS IS TAKING WAY TOO LONG."}, :status => '404'
    end
  end

  def show
  end

end

# e.response.params["Response"]["Error"].first["ErrorDescription"]

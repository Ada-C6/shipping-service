require 'timeout'

class ShipmentsController < ApplicationController

  def index
    begin
      status = Timeout::timeout(10){
        render :json => ShippingRateGetter.get_rates(params[:weight].to_f, params[:origin_zip].to_i, params[:destination_zip].to_i), :status => :ok
      }
    rescue ActiveShipping::ResponseError => e
      render :json => {error: "UH-OH. LOOKS LIKE SOMETHING'S NOT QUITE RIGHT. PERHAPS YOUR ZIP CODES ARE OFF BY ONE? PLEASE NOTE: PACKAGES HAVE A WEIGHT LIMIT OF 150 LBS."}, :status => '404'
    rescue Timeout::Error
      render :json => {error: "THIS IS TAKING WAY TOO LONG. SORRY, BUT THIS IS NOW A TIMEOUT ERROR. TRY GOING BACK AND REFRESHING THE PAGE AND SUBMITTING YOUR REQUEST AGAIN."}, :status => '404'
    end
  end

  def show
  end

end

# e.response.params["Response"]["Error"].first["ErrorDescription"]

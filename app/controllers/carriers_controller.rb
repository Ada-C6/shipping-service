class CarriersController < ApplicationController

  def index
    render :json => ShippingRateGetter::CARRIERS, :status => :ok
  end
  
end

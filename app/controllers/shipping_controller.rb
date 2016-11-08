class ShippingController < ApplicationController

  def index
    shippings = Shipping.all
    render json: shippings
  end

end

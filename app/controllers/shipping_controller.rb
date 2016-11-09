class ShippingController < ApplicationController

  def index
    shippings = Shipping.new
    render json: shippings
  end

end

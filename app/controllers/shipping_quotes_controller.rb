class ShippingQuotesController < ApplicationController

  def index
    render json: params
  end
end

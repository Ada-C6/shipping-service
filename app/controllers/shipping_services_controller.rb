class ShippingServicesController < ApplicationController

  def search
    # All the shipping options for a given package/origin/destination, by calling the ShippingOption model search method.
    # options = ShippingOption.search(params[:query])
    options = []
    render json: options
  end

  def show
    # The details of a specific shipping option.
  end
end

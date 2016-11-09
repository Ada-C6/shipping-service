class ShippingServicesController < ApplicationController

  def search
    # All the shipping options for a given package/origin/destination, by calling the ShippingOption model search method.
    # TODO: After the in-class discussion, we realize that instead of passing in the specific params, we should make a query hash and strong params. Will fix if we have time.

    begin
      options = ShippingOption.search(params[:origin], params[:destination], params[:package])
    rescue ArgumentError
      render nothing: true, status: :bad_request and return
    end
    # if there is no ArgumentError we render the options.
    # if there is an ArugmentError, we will have returned out of the action
    render json: options

  end

  def show
    option = ShippingOption.find_by(id: params[:id])
    unless option.nil?
      # The details of a specific shipping option.
      render json: option
    else
      render nothing: true, status: :not_found
    end
  end
end

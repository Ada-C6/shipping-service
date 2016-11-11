class RatesController < ApplicationController
  def index
    shipment = Shipment.find(params[:shipment_id])
    results = shipment.rates
    render json: results
  end

  def show
    rate = Rate.find_by(id: params[:id])
    if rate
      render json: rate
    else
      render status: :not_found, nothing: true
    end
  end

end

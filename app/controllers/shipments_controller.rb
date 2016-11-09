class ShipmentsController < ApplicationController
  def index
    s = Shipment.create(params)
    s.ups_rates
    s.usps_rates
    results = s.rates
    render json: results
  end

  

end

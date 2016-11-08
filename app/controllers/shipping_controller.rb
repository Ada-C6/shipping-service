class ShippingController < ApplicationController
  def search
    shipment_hash = {
      weight: params[:weight].to_f,
      origin_country: params[:origin_country],
      origin_state: params[:origin_state],
      origin_city: params[:origin_city],
      origin_zip: params[:origin_zip],
      destination_country: params[:destination_country],
      destination_state: params[:destination_state],
      destination_city: params[:destination_city],
      destination_zip: params[:destination_zip]
    }

    results = ShippingRate.get_rates(shipment_hash)

    render json: results, except: [:created_at, :updated_at]
  end
end

# response I send should look like:
[
{"id": 1, "name": "UPS Ground", "cost": 20.41},
{"id": 2, "name": "UPS Second Day Air", "cost": 82.71},
{"id": 3, "name": "FedEx Ground", "cost": 20.17},
{"id": 4, "name": "FedEx 2 Day", "cost": 68.46},
]

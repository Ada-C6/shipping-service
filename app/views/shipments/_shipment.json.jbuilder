json.extract! shipment, :id, :created_at, :updated_at
json.url shipment_url(shipment, format: :json)

class RateSerializer < ActiveModel::Serializer
  attributes :id, :service_name, :shipment_id, :total_price
end

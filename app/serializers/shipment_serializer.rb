class ShipmentSerializer < ActiveModel::Serializer
  attributes :id, :country, :city, :state, :zip, :weight, :length, :width, :height
end

class Quote < ActiveRecord::Base
  belongs_to :shipment
  validates :name, presence: :true
  validates :price, presence: :true, numericality: { only_integer: true }
  validates :shipment_id, presence: :true, numericality: true

  def by_shipment

  end
end

class Quote < ActiveRecord::Base
  belongs_to :shipment
  validates :name, presence: :true
  validates :price, presence: :true #could add numericality
  validates :shipment_id, presence: :true
  
  def by_shipment

  end
end

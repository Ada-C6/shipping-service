# require 'active_shipping'

class Shipment < ActiveRecord::Base
  validates :weight, presence: true
  validates :height, presence: true
  validates :length, presence: true
  validates :width, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :zipcode, presence: true
  validates :units, presence: true

  def origin
    # Normally this wouldn't be hardcoded, but the limitations of the
    # project necessitate it.
    return ActiveShipping::Location.new(country: "United States", state: "WA", city: "Seattle", postal_code: "98161")
  end


  #This method works for both origin and destination
  def destination
    return ActiveShipping::Location.new(country: country, state: state, city: city, postal_code: zipcode)
  end

end

class Location < ActiveRecord::Base
  belongs_to :shipment

  validates :country, :state, :city, :zip, presence: true

  attr_reader :country, :state, :city, :zip

  def initialize (country, state, city, zip)
    @country = country
    @state = state
    @city = city
    @zip = zip
  end
end

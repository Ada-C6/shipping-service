class Shipment < ActiveRecord::Base
  has_many :quotes
  validates :city, presence: true
  validates :weight, presence: true, numericality: true
  validates :zip, presence: true, numericality: { only_integer: true }, length: {is: 5}

  def get_destination
    return ActiveShipping::Location.new(country: self.country, city: self.city, zip: self.zip)
  end

  def get_origin
    return ActiveShipping::Location.new(country: "US", city: "Seattle", zip: 98116)
  end

  def get_package
    return ActiveShipping::Package.new(self.weight, [self.length, self.width, self.height], units: :imperial)
  end

  def ups_rates
    ups = ActiveShipping::UPS.new(login: ENV["ACTIVESHIPPING_UPS_LOGIN"], password: ENV["ACTIVESHIPPING_UPS_PASSWORD"], key: ENV["ACTIVESHIPPING_UPS_KEY"])
    dest = get_destination
    pack = []
    pack << get_package
    origin = get_origin

    response = ups.find_rates(origin, dest, pack)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return ups_rates
  end

  def usps_rates
    usps = ActiveShipping::USPS.new(login: ENV["ACTIVESHIPPING_USPS_LOGIN"])
    dest = get_destination
    pack = []
    pack << get_package
    origin = get_origin
    response = usps.find_rates(origin, dest, pack)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    return usps_rates
  end

  def all_rates
    usps_rates + ups_rates
  end

  def generate_quotes
    quote_array = []
    all_rates.each do |rate|
      quote_array << Quote.create(shipment_id: self.id, name: rate[0], price: rate[1])
    end
    return quote_array
  end
end

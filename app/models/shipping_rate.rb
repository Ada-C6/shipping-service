class ShippingRate < ActiveRecord::Base
  def self.get_rates(shipment_hash)
    ounces = shipment_hash[:weight]
    dimensions = [12, 12, 12]

    package = ActiveShipping::Package.new(ounces, dimensions, units: :imperial)

    origin = ActiveShipping::Location.new(
    country: shipment_hash[:origin_country], state: shipment_hash[:origin_state],
    city: shipment_hash[:origin_city],
    zip: shipment_hash[:origin_zip])

    destination = ActiveShipping::Location.new(
    country: shipment_hash[:destination_country],
    state: shipment_hash[:destination_state],
    city: shipment_hash[:destination_city],
    zip: shipment_hash[:destination_zip])

    usps = ActiveShipping::USPS.new(login: '677JADED7283')

    response = usps.find_rates(origin, destination, package)

    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    all_rates = []

    usps_rates.each do |rate|
      all_rates << ShippingRate.create(name: rate[0], cost: rate[1])
    end

    return all_rates
  end

  # def packager(shipment)
  #   package_array.each do |package_hash|
  #     ActiveShipping::Package.new
  #   end
  # end
end

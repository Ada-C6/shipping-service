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
    response_usps = usps.find_rates(origin, destination, package)
    usps_rates = response_usps.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    ups = ActiveShipping::UPS.new(login: 'shopifolk', password: 'Shopify_rocks', key: '7CE85DED4C9D07AB')
    response_ups = ups.find_rates(origin, destination, package)
    ups_rates = response_ups.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    all_rates = []

    usps_rates.each do |rate|
      all_rates << ShippingRate.create(name: rate[0], cost: rate[1])
    end
    
    ups_rates.each do |rate|
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

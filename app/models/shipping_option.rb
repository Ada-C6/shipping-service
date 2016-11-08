class ShippingOption < ActiveRecord::Base
  validates :name, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.search(query)
    # This is where we call Active shipping given a package, origin, and destination, we'll create new ShippingOption objects and return them in an array.
    # query is going to be a hash with three keys: package, destination (a location call), and origin (a location call).

    @package = Self.package(19)


  end

  def self.package(package_weight)
    raise ArgumentError, 'Package Weight cannot be less than zero' if package_weight < 0
    # First, we make a package based on the info we get from query[:package]
    package = ActiveShipping::Package.new(
      package_weight * 16, # weight times 16 oz/lb.
      [10, 10, 5],     # 10x10x5 inches
      units: :imperial)  # not grams, not centimetres

    return package
  end

  def self.location(zip_code)
    # Then, we make a location used for either the origin or destination, based on the info we get from query[:origin/:destination]
    raise ArgumentError, 'Zip code must be valid' if (99951 < zip_code.to_i || zip_code.to_i < 1000)

    location = ActiveShipping::Location.new(country: 'US', zip: zip_code)

    return location
  end

  def self.get_rates_from_provider(provider, origin, destination, package)
    # This is where we call activeshipper for a given provider and get back their rates
    response = provider.find_rates(origin, destination, package)
    return response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

  def ups_rates
  end

  def usps_rates
  end
end

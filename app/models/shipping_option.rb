class ShippingOption < ActiveRecord::Base
  validates :name, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.search(origin, destination, package)
    # This is where we call Active shipping given a package, origin, and destination, we'll create new ShippingOption objects and return them in an array.
    # query is going to be a hash with three keys: package, destination (a location call), and origin (a location call).
    # Something like ShippingOption.search(params[:package], etc)

    # First, we make a package based on the info we get from params[:package]
    orig = location(origin)
    dest = location(destination)
    pack = create_package(package)

    # initialize an empty array to store all our objects
    options = []

    ups_rates = get_rates_from_provider(self.ups, orig, dest, pack)

    ups_rates.each do |rate|
      # cost.to_f/100 because Petsy expects cost in dollars not cents
      options << ShippingOption.create(name: rate[0], cost: rate[1].to_f/100)
    end

    usps_rates =  get_rates_from_provider(self.usps,orig,dest,pack)

    usps_rates.each do |rate|
      options << ShippingOption.create(name: rate[0], cost: rate[1].to_f/100)
    end

    return options
  end

  def self.create_package(package_weight)
    raise ArgumentError, 'Package Weight cannot be less than zero' if package_weight.to_i <= 0

    package = ActiveShipping::Package.new(
      package_weight.to_i * 16, # weight times 16 oz/lb.
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
    # an example provider is an ActiveShipping::UPS.new object
    raise ArgumentError unless ((provider.class == ActiveShipping::USPS) || (provider.class == ActiveShipping::UPS))

    response = provider.find_rates(origin, destination, package)
    return response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
  end

  def self.ups
    ups = ActiveShipping::UPS.new(login: ENV['ACTIVESHIPPING_UPS_LOGIN'], password: ENV['ACTIVESHIPPING_UPS_PASSWORD'],
    key: ENV['ACTIVESHIPPING_UPS_KEY'] )

    return ups
  end

  def self.usps
    usps = ActiveShipping::USPS.new(login: ENV['ACTIVESHIPPING_USPS_LOGIN'])

    return usps
  end
end

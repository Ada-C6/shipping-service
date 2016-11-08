class ShippingOption < ActiveRecord::Base
  validates :name, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.search(query)
    # This is where we call Active shipping given a package, origin, and destination, we'll create new ShippingOption objects and return them in an array.
    # query is going to be a hash with three keys: package, destination, and origin.


  end

  def self.package(package_weight)
    # First, we make a package based on the info we get from query[:package]
    package = ActiveShipping::Package.new(
      package_weight * 16, # weight times 16 oz/lb.
      [10, 10, 5],     # 10x10x5 inches
      units: :imperial)  # not grams, not centimetres

    return package
  end

  def origin
    # Then, we make an origin, based on the info we get from query[:origin]
  end

  def destination
    # Then we make a destination, based on the info we get from query[:destination]
  end

  def get_rates_from_provider(provider)
    # This is where we call activeshipper for a given provider and get back their rates
  end

  def ups_rates
  end

  def usps_rates
  end
end

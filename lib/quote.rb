require 'timeout'
class Quote

  UPS_LOGIN = ENV["ACTIVESHIPPING_UPS_LOGIN"]
  UPS_KEY = ENV["ACTIVESHIPPING_UPS_KEY"]
  UPS_PASSWORD = ENV["ACTIVESHIPPING_UPS_PASSWORD"]
  USPS_LOGIN = ENV["ACTIVESHIPPING_USPS_LOGIN"]

  attr_reader :package, :origin, :destination

  def initialize(weight, origin = {}, destination = {}, dimensions = [15, 10, 4.5])
    raise ArgumentError, 'Must supply a weight to calculate quote.' unless weight

    @package = ActiveShipping::Package.new(weight.to_i*16, dimensions, units: :imperial)

    #update the params when we create API wrapper in Petsy
    @origin = ActiveShipping::Location.new({country: 'US', state: 'WA', city: 'Seattle',zip: '98122'})
    @destination = ActiveShipping::Location.new(destination)
  end

  def ups
    ups = ActiveShipping::UPS.new(login: UPS_LOGIN, password: UPS_PASSWORD, key: UPS_KEY)


    ups_response = Timeout::timeout(5) { ups.find_rates(@origin, @destination, @package) }
    # return ups_response.rates
    ups_rates = {}
    ups_response.rates.sort_by(&:price).each do |rate|
      ups_rates[rate.service_name] = [rate.price, rate.delivery_date]
    end
    return ups_rates
  end

  def usps
    usps = ActiveShipping::USPS.new(login: USPS_LOGIN)
    response = usps.find_rates(@origin, @destination, @package)
    usps_rates = {}
    response.rates.sort_by(&:price).each do |rate|
      usps_rates[rate.service_name] = [rate.price, rate.delivery_date]
    end
    return usps_rates

  end
end

class Quote

  def initialize(weight, origin = {}, destination = {}, dimensions = [15, 10, 4.5])

    @package = ActiveShipping::Package.new(weight, dimensions, units: :imperial)
    #update the params when we create API wrapper in Petsy
    @origin = ActiveShipping::Location.new({country: 'US', state: 'WA', city: 'Seattle',zip: '98122'})
    @destination = ActiveShipping::Location.new(destination)
  end

  def ups
    ups = ActiveShipping::UPS.new(login: "shopifolk", password: "Shopify_rocks", key: "7CE85DED4C9D07AB")

    ups_response = ups.find_rates(@origin, @destination, @package)

    ups_rates = {}
    ups_response.rates.sort_by(&:price).each do |rate|
      ups_rates[rate.service_name] = rate.price
    end
    return ups_rates
  end
end

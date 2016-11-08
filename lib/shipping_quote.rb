require 'active_shipping'

class ShippingQuote

UPS_LOGIN = ENV['ACTIVESHIPPING_UPS_LOGIN']
UPS_KEY = ENV['ACTIVESHIPPING_UPS_KEY']
UPS_PASSWORD = ENV['ACTIVESHIPPING_UPS_PASSWORD']

  def initialize(package, origin, destination)
    @package = package
    @origin = origin
    @destination = destination
    @service_quotes = []
  end

  #Method will return service_quotes from the requested carrier (through an ActiveShipping object) as an array of arrays
  # Currently supports UPS
  def requesting_quote(carrier)
    if carrier == "ups"
      ups_credentials = ActiveShipping::UPS.new(login: UPS_LOGIN, password: UPS_PASSWORD, key: UPS_KEY)
      response = ups_credentials.find_rates(@origin, @destination, @package)

      # UPS rates/quotes
      return ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    end
  end

end

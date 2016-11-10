require 'active_shipping'

class ShippingQuote
attr_reader :origin, :destination, :package
  UPS_LOGIN = ENV['ACTIVESHIPPING_UPS_LOGIN']
  UPS_KEY = ENV['ACTIVESHIPPING_UPS_KEY']
  UPS_PASSWORD = ENV['ACTIVESHIPPING_UPS_PASSWORD']
  USPS_LOGIN = ENV['ACTIVESHIPPING_USPS_LOGIN']

  def self.setup(weight, origin_hash, destination_hash )
    package = ActiveShipping::Package.new(weight, [12, 12, 12 ], cylinder: true)
    origin = ActiveShipping::Location.new(origin_hash)
    destination =   ActiveShipping::Location.new(destination_hash)
    @parcel = ShippingQuote.new(package, origin, destination)
  end

  def initialize(package, origin = {}, destination = {})
    @package = package
    @origin = origin
    @destination = destination
  end

  #Method will return service_quotes from the requested carrier (through an ActiveShipping object) as JSON
  # Currently supports UPS
  def requesting_quote(carrier)
    if carrier == "ups"
      ups_credentials = ActiveShipping::UPS.new(login: UPS_LOGIN, password: UPS_PASSWORD, key: UPS_KEY)
      response = ups_credentials.find_rates(@origin, @destination, @package)
      # UPS rates/quotes [ [],[],... ]
      # return response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    elsif carrier == "usps"
      usps = ActiveShipping::USPS.new(login: USPS_LOGIN)
      response = usps.find_rates(@origin, @destination, @package)
      # return  response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    end
    parcel_quotes = []
    quote = {}
    if response != nil
    response.rates.each do |rate|
        if rate.service_name && rate.total_price
          quote[:name] = rate.service_name
          quote[:cost] = rate.total_price
          parcel_quotes << quote
        else
          return nil
        end
      end
      return parcel_quotes # this is an array of hash
    else
      return nil
    end
  end

  def carrier_quotes(carriers)
    quotes = []
    carriers.each do |carrier|
      requesting_quote(carrier).each do |quote|
        quotes << quote
      end
    end
    return quotes # array of arrays
  end

end

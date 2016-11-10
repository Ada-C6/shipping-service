require 'active_shipping'

class ShippingQuote

  UPS_LOGIN = ENV['ACTIVESHIPPING_UPS_LOGIN']
  UPS_KEY = ENV['ACTIVESHIPPING_UPS_KEY']
  UPS_PASSWORD = ENV['ACTIVESHIPPING_UPS_PASSWORD']
  USPS_LOGIN = ENV['ACTIVESHIPPING_USPS_LOGIN']



  def self.setup(weight, origin_hash, destination_hash )
    package = ActiveShipping::Package.new(weight, [12, 12, 12 ], cylinder: true)
    origin = ActiveShipping::Location.new(origin_hash)
    destination =   ActiveShipping::Location.new(destination_hash)
    ShippingQuote.new(package, origin, destination)

  end

  def initialize(package, origin = {}, destination = {})
    @package = package
    @origin = origin
    @destination = destination
  end

  #Method will return service_quotes from the requested carrier (through an ActiveShipping object) as an array of arrays
  # Currently supports UPS
  def requesting_quote(carrier)
    if carrier == "ups"
      ups_credentials = ActiveShipping::UPS.new(login: UPS_LOGIN, password: UPS_PASSWORD, key: UPS_KEY)
      response = ups_credentials.find_rates(@origin, @destination, @package)

      # UPS rates/quotes [ [],[],... ]
      return response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    elsif carrier == "usps"
      usps = ActiveShipping::USPS.new(login: USPS_LOGIN)
      response = usps.find_rates(@origin, @destination, @package)
      return response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    end
  end
  #
  # def self.origin(origin_hash)
  #   ActiveShipping::Location.new(origin_hash)
  # end
  #
  # def self.destination(destination_hash)
  #   ActiveShipping::Location.new(destination_hash)
  # end
  #
  # def self.package(weight)
  #   ActiveShipping::Package.new(weight, [12, 12, 12 ], cylinder: true)
  # end
  # # method putting quotes together parcel.carrier_quotes([ups,usps,canadapost] )
  def carrier_quotes(carriers)
    quotes = []
    carriers.each do |carrier|
      requesting_quote(carrier).each do |quote|
        quotes << quote
      end
    end
    return quotes
  end

  # def self.build_quote #(package, origin, destination, service_quotes =[])
  #   return ShippingQuote.new(@package, @origin, @destination, quotes)
  # end

end

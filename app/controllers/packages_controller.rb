require 'active_shipping'

class PackagesController < ApplicationController
  PACKAGE_KEYS = %w( weight state city zip )
  O_COUNTRY = "USA"
  O_STATE = "WA"
  O_CITY = "Seattle"
  O_ZIP = "98161"

  D_COUNTRY = "USA"

  SIZE_WIDTH = 12
  SIZE_HEIGHT = 15
  SIZE_LENGTH = 4.5
  ORIGIN = ActiveShipping::Location.new(country: O_COUNTRY, state: 'WA', city: 'Seattle', postal_code: '98102')
  UPS_LOGIN = ENV['ACTIVESHIPPING_UPS_LOGIN']
  PASSWORD = ENV['ACTIVESHIPPING_UPS_PASSWORD']
  KEY = ENV['ACTIVESHIPPING_UPS_KEY']
  USPS_LOGIN = ENV['ACTIVESHIPPING_USPS_LOGIN']

  def find_rate

    logger.info(">>>>>>>> #{params}")

    packages =
    [
      ActiveShipping::Package.new(params[:weight].to_i, [SIZE_LENGTH, SIZE_HEIGHT, SIZE_WIDTH], units: :imperial)
    ]

    destination = ActiveShipping::Location.new(country: D_COUNTRY, state: params[:state], city: params[:city], postal_code: params[:zip])

    rates = get_rates(ORIGIN, destination, packages)

    response = {"shipping_rates" => rates}

    logger.info("<<<<<<<<<<< #{response}")

    # if response
      render json: response, status: :created
    # else
    #   render status: :not_found, nothing: true
    # end

  rescue ActiveShipping::ResponseError => error
    render json: { "error": error.response.message }
  end

  def get_rates(origin, destination, packages)
    usps = ActiveShipping::USPS.new(login: USPS_LOGIN)
    response_one = usps.find_rates(ORIGIN, destination, packages)

    ups = ActiveShipping::UPS.new(login: UPS_LOGIN,
    password: PASSWORD, key: KEY)
    response_two = ups.find_rates(ORIGIN, destination, packages)

    track_response = []

    response_one.rates.each do |rate|
      track_response << rate
    end
    response_two.rates.each do |rate|
      track_response << rate
    end

    rates =[]
    track_response.each do |rate|
      shipping_rate = {}
      shipping_rate[:name] = rate.service_name
      shipping_rate[:cost] = ((rate.total_price.to_f)/100)
      if !(rate.delivery_range.empty?)
        shipping_rate[:delivery] = rate.delivery_range
      end
      rates << shipping_rate
    end
    return rates
  end
end

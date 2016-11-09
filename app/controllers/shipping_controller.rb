require 'active_shipping'
require 'ship_wrapper'

class ShippingController < ApplicationController
  def quote

    request = Request.new(weight: params[:weight], length: params[:length], width: params[:width], height:params[:height], buyer_country:params[:country], buyer_state:  params[:state], buyer_city: params[:city], buyer_zip: params[:zip])

    request.save

    package = ActiveShipping::Package.new(request.weight,
                                          [request.length,
                                          request.width, request.height])

    # Need to be a CONSTANT. Where to put the constant?

    destination = ActiveShipping::Location.new(country: request.buyer_country,
                                             state: request.buyer_state,
                                            city: request.buyer_city,
                                           zip: request.buyer_zip)

  rates =  ShipWrapper.get_rates("usps", package, destination)

  rates.each do |rate_array|
    Quote.create(carrier: rate_array[0], rate: rate_array[1], request_id: params[:id])
  end

  list_of_quotes = Quote.where(request_id: params[:id])


  render :json => list_of_quotes.as_json

  end
end

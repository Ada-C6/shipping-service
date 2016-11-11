class ShippingQuotesController < ApplicationController
CARRIERS = ["ups", "usps"]

  def index
    puts ">>>>>>>>#{params}"
    logger.info(weight = params["weight"].to_f)

    logger.info(origin_hash = {country: params["origin"]["origin_country"], state: params["origin"]["origin_state"], city: params["origin"]["origin_city"], zip: params["origin"]["origin_zip"]})

    logger.info(destination_hash = {country: params["destination"]["destination_country"], state: params["destination"]["destination_state"], city: params["destination"]["destination_city"], zip: params["destination"]["destination_zip"]})

    parcel = ShippingQuote.setup(weight, origin_hash, destination_hash)



    render json: parcel.carrier_quotes(CARRIERS)
  end

end

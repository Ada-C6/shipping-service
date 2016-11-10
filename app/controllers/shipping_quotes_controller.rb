class ShippingQuotesController < ApplicationController


  def index
    puts ">>>>>>>>#{params}"
    weight = params["weight"].to_f

    origin_hash = {country: params["origin"]["origin_country"], state: params["origin"]["origin_state"], city: params["origin"]["origin_city"], zip: params["origin"]["origin_zip"]}

    destination_hash = {country: params["destination"]["destination_country"], state: params["destination"]["destination_state"], city: params["destination"]["destination_city"], zip: params["destination"]["destination_zip"]}

    ShippingQuote.setup(weight, origin_hash, destination_hash)



    render json: packages
  end

end

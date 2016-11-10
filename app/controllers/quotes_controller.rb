class QuotesController < ApplicationController
  def create
    weight = params["weight"]
    destination = params["destination"]
    logger.info(">>>>>>>>>>>REQUEST: #{params}")
    begin
      quote = Quote.new(weight, nil, destination)
    rescue ArgumentError => err
      render json: {error: err.message}, status: 400 and return
    end

    begin
      quotes = {ups: quote.ups, usps: quote.usps}
    rescue ActiveShipping::ResponseError => err
      render json: { "error": err.response.message }, status: 400 and return
    end
    logger.info(render json: { quotes: quotes }
  end
end


# in Petsy, HTTParty.post(body: {}, headers: {"Content-Type": application/json'})

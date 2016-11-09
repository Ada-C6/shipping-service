class QuotesController < ApplicationController
  def create
    weight = params["weight"]
    destination = params["destination"]
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
    render json: { quotes: quotes }

  end
end


# in Petsy, HTTParty.post(body: {}, headers: {"Content-Type": application/json'})

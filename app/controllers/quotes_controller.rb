class QuotesController < ApplicationController
  def create
    weight = params["weight"]
    destination = params["destination"]
    quote = Quote.new(weight, nil, destination)
    quotes = {ups: quote.ups, usps: quote.usps}
    render json: { quotes: quotes }
  end
end


# in Petsy, HTTParty.post(body: {}, headers: {"Content-Type": application/json'})

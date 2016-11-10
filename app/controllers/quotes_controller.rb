class QuotesController < ApplicationController
  def create
    weight = params["weight"]
    destination = params["destination"]
    logger.info(">>>>>>>>>>>REQUEST: #{params}")
    begin
      quote = Quote.new(weight, nil, destination)
    rescue ArgumentError => err
      logger.info(">>>>>>>>>>>RESPONSE: { 'error': #{err.message} }")
      render json: { error: err.message }, status: 400 and return
    end

    begin
      begin
      rates = {ups: quote.ups, usps: quote.usps}
    rescue ActiveShipping::ResponseError => err
      logger.info(">>>>>>>>>>>RESPONSE: { 'error': #{err.response.message} }")
      render json: { error: err.response.message }, status: 400 and return
      rescue Timeout::Error => err
      logger.info(">>>>>>>>>>>RESPONSE: { 'error': #{err.message} }")
      render json: { error: err.message }, status: 504 and return
      end
    end
    logger.info(">>>>>>>>>>>RESPONSE: { 'rates': #{rates} }")
    render json: rates, status: :ok
  end
end


# in Petsy, HTTParty.post(body: {}, headers: {"Content-Type": application/json'})

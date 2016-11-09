require "#{Rails.root}/lib/zipcode_api_wrapper"

class QuotesController < ApplicationController
  SHIPPING_PER_MILE = 0.01
  NAME = "UPS"

  def index
  end

  def show
  end

  def new
  end

  def create
    # This is what a valid query from Petsy should look like:
    # http://localhost:3000/quotes/create?weight=8&from=92675&to=98034
    distance = Zipcode_Api_Wrapper.get_distance(params["from"], params["to"])
    cost = (params[:weight].to_f * SHIPPING_PER_MILE) * distance.to_i
    quotes = {cost: cost, name: NAME, id: 1}
    render :json => quotes, :status => :ok
  end

  def edit
  end

  def update
  end

  def destroy
  end
end

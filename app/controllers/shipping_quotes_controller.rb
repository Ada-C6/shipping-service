class ShippingQuotesController < ApplicationController


  def index
    puts ">>>>>>>>#{params}"
    packages = [ActiveShipping::Package.new(params["weight"].to_i, [12, 12, 12 ], cylinder: true)]
    render json: packages
  end

end

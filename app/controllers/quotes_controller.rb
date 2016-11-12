require 'timeout'

class QuotesController < ApplicationController

    def index
      logger.info(">>>>>>> AHSK: #{ request.body.read }")
      logger.info(">>>>>>> AHSK: #{ response }")
      logger.info(">>>>>>> AHSK: #{ shipment_params }")
      begin
        status = Timeout::timeout(10) {
          quote = Shipment.new(shipment_params)
          render json: { "quotes": quote.all_quotes }, status: :created
        }
      rescue ActiveShipping::ResponseError
        render status: :not_found, nothing: true
      end
    end


    private
    def shipment_params
        # params.require(:shipment).permit(:weight, :country, :state, :city, :zip)
        # ^^ we are hard coding these below to get our controller to work - these will normally come in from petsy's api-wrapper
      { weight: 15, country: 'US', state: 'OH', city: 'Akron', zip: '44333' }
    end
end

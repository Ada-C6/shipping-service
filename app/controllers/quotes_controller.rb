require 'shipment'
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
        render json: {}, status: :not_found
      end
    end


    private
    def shipment_params
        # params.require(:shipment).permit(:weight, :country, :state, :city, :zip)
        # ^^ we are hard coding these below to get our controller to work - these will normally come in from petsy's api-wrapper
      { weight: 15, country: 'US', state: 'OH', city: 'Akron' }
    end

end

ActiveShipping::ResponseError
# # Pet data from the user looks like
# # { "pet": {"name": "fido", "age": 3, "human": "ada"}}
# def create
#     logger.info(">>>>> DPR: #{request.body.read}")
#     logger.info(">>>>> DPR: #{params}")
#     pet = Pet.new(pet_params)
#     pet.save
#     render json: { "id": pet.id }, status: :created
# end
#
# private
# def pet_params
#     params.require(:pet).permit(:name, :age, :human)
# end
# end

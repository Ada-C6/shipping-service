class QuotesController < ApplicationController
    def create
        logger.info(">>>>>>> AHSK: #{ request.body.read }")
        logger.info(">>>>>>> AHSK: #{ params }")
        quote = Shipment.new(shipment_params)
        render json: { "quotes": quote.all_quotes }, status: :created
    end


    private
    def shipment_params
        params.require(:shipment).permit(:weight, :country, :state, :city, :zip)
    end

end


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

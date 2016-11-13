require 'timeout'

class QuotesController < ApplicationController

    def index
        # the below line is commented out because the current answer is always blank since we are hard-coding our input in for these current requirements:
        # logger.info(">>>>>>> AHSK: #{ request.body.read }")
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
        # I (Suzannah) am owning our below requirement test coverage of this file. I wanted to use line 27 (below) to test a 'negative' test case of this controller's index method. I researched that nested cassettes are possible, so I wrote a test in quotes_controller_test.rb, line 42. However, I don't know how to work these positive and negative tests AT THE SAME TIME given that we're hard-coding our input here into the controller. If line 25 in this doc is commented out and line 27 below is active, then only the controller test on line 42 will pass (yay, the nested cassette functionality works!). Unfortunately, all other three tests will fail. So, I'm including line 26 and 27 of this file (as well as line 42-50 in our quotes_controller_test.rb) ALL AS COMMENTS because I want to describe the efforts attempted to increase this file's test coverage. Kari or Dan, could you please explain to us how it's possible to test both the positive and negative test cases while hard-coding our input? Now I'm really curious if it's possible, given the specifics of this project and how our code is written! My guess is that our code needs to be tweaked, I'm just now sure how. Thanks!
        # { weight: 15, country: 'US', state: 'OH', city: 'Akron' }
    end
end

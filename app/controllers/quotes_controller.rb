class QuotesController < ApplicationController
    def index
      options = Quote.find_rates(params[:weight], params[:o_zip], params[:d_zip])
        render json: options # each is an array of arrays
    end


end
ups = ActiveShipping::UPS.new(login: 'auntjudy', password: 'secret', key: 'xml-access-key')
 ups_response = ups.find_rates(params[:origin], params[:destination], params[:packages])

usps = ActiveShipping::UPS.new
 usps_response = ups.find_rates(origin, destination, packages)

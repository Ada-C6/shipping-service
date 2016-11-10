class QuotesController < ApplicationController
    def index
      options = Quote.find_rates(params[:weight], params[:o_zip], params[:d_zip])
        render json: options # each is an array of arrays
    end
end

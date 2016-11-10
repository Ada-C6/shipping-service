class ShippingServicesController < ApplicationController
  def show
  	weight=params[:weight]
  	weight=weight.to_f if weight and weight != ''
  	dest_zip=params[:to]
  	service=params[:service]
  
   response = ShippingCalculator.calc_shipping(weight,dest_zip,service)
   #puts response.as_json

   unless response.class == Array
    	status = :not_found 
   else
    	status = :ok
   end

   render :json => response, :status => status
  end
end

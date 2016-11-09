class ShippingServicesController < ApplicationController
  def show
  	weight=params[:weight]
  	weight.to_f if weight and weight != 0 and weight != nil
  	dest_zip=params[:to]
  	service=params[:service]
  
   response = ShippingCalculator.calc_shipping(weight,dest_zip,service)
   puts response.as_json

   if response[:error] 
    	status = :not_found 
   else
    status = :ok
   end

   render :json => response, :status => status
  end
end

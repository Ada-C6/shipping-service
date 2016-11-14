class ShippingServicesController < ApplicationController
  def show
  	weight=params[:weight]
  	weight=weight.to_f if weight and weight != ''
  	dest_zip=params[:to]
  	service=params[:service]
  	request=Request.create({verb: 'get', body: params})

   response = ShippingCalculator.calc_shipping(weight,dest_zip,service)
   unless response.class == Array
    	status = :not_found 
   else
    	status = :ok
   end

   log_response=Response.create({JSON_hash: response, status_code: status, request_id: request.id})
   render :json => response, :status => status
  end
end

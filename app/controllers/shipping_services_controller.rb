class ShippingServicesController < ApplicationController
  def show
  	weight=params[:weight].to_f
  	dest_zip=params[:to]
  	service=params[:service]
  	
   response = ShippingCalculator.calc_shipping(weight,dest_zip,service)
   #usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
   
   render :json => response.as_json, :status => :ok
  	#error cases
  	#change to create

  end
end

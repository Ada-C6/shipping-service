class ShippingServicesController < ApplicationController
  def show
  	weight=params[:query]
  	dest_zip=params[:dest_zip]


  	#package=Package.save(weight: weight, destination_zip: dest_zip)
    ActiveShipping::Package.new(weight * 16,          
                             	[10, 10, 10],     
                             	units: :imperial) 	

    render :json => package.as_json, :status => :ok
  end
end

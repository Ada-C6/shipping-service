class ShippingCalculator

	def self.calc_shipping(weight,dest_zip,service)
		zip_info=ZipCodes.identify(dest_zip)

	  	#package=Package.save(weight: weight, destination_zip: dest_zip)
	   package=ActiveShipping::Package.new(weight * 16,          
	                             	[10, 10, 10],     
	                             	units: :imperial) 	

	   destination = ActiveShipping::Location.new(country: 'US',
	                                       state: zip_info[:state_code],
	                                       city: zip_info[:city],
	                                       zip: dest_zip)

	   origin = ActiveShipping::Location.new(country: 'US',
	                                       state: 'WA',
	                                       city: "Seattle",
	                                       zip: '98122')

	  	#change login stuff to environment variables
	  	case service
	  	when 'usps'
	   		usps = ActiveShipping::USPS.new(login: ENV['USPS_LOGIN'])
	   		response = usps.find_rates(origin, destination, package)
	   		
	   	when 'ups'
	   		ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
	   		response = ups.find_rates(origin, destination, package)
	   	end 
	   return response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

	end
end
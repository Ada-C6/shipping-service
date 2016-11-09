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
	  	case service
	  	when 'usps'
	   		usps = ActiveShipping::USPS.new(login: '527118306406')
	   		response = usps.find_rates(origin, destination, package)
	   	when 'ups'
	   		ups = ActiveShipping::UPS.new(login: 'shopifolk', password: 'Shopify_rocks', key: '7CE85DED4C9D07AB')
	   		response = ups.find_rates(origin, destination, package)
	   	end 
	   return response

	end
end
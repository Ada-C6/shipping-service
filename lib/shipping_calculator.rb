class ShippingCalculator

	def self.calc_shipping(weight,dest_zip,service)
		params_exist_status={"weight"=>weight, 
							 "destination zip"=>dest_zip,
							  "service" => service}

		# puts "weight: #{params_exist_status["weight"]}"
		missing_ones = params_exist_status.select { |key, value| value==nil or value==''}
	
		unless missing_ones.empty?
			return {"error"=> "The following parameters are missing #{missing_ones.keys} "}
		end 
	
		zip_info=ZipCodes.identify(dest_zip)

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
	   		usps = ActiveShipping::USPS.new(login: ENV["USPS_LOGIN"])
	   		response = usps.find_rates(origin, destination, package)
	   		
	   	when 'ups'
	   		ups = ActiveShipping::UPS.new(login: ENV["UPS_LOGIN"], password: ENV["UPS_PASSWORD"], key: ENV["UPS_KEY"])
	   		response = ups.find_rates(origin, destination, package)
	   	end 
	   	
	   	arr=response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
	   	hashy={}
	   	outside=[]
	   	arr.each_with_index do |a, index|
	   		hashy[:id]= index+1
	   		hashy[:name]= a.first
	   		hashy[:cost]= a.last/100.0 
	   		outside<<hashy
	   		hashy={}
	   	end

	   	return outside
	end
end
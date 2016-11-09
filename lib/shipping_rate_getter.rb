class ShippingRateGetter

  CARRIERS = ["UPS", "USPS", "Fedex"]

  def self.get_rates(weight, origin_zip, destination_zip, size = [12,12,12])

    package = ActiveShipping::Package.new(weight*16, size, units: :imperial)
    sender = ActiveShipping::Location.new(country: 'US', zip: origin_zip)
    receiver = ActiveShipping::Location.new(country: 'US', zip: destination_zip)

    request = Request.new(weight: weight, origin_zip: origin_zip, destination_zip: destination_zip, length: size[0], width: size[1], height: size[2])
    request.save

    results_hash = {}

    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
    ups_response = ups.find_rates(sender, receiver, package)
    ups_response_trimmed = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}

    results_hash["UPS"] = ups_response_trimmed

    results_hash["UPS"].each do |line|
      method = line[0]
      cost = line[1]

      if line[2] != []
        delivery_estimate = line[2].first
      else
        delivery_estimate = nil
      end

      request.results << Result.create(price: cost, provider: "UPS", service: method, delivery_est: delivery_estimate)
    end


    usps = ActiveShipping::USPS.new(login: ENV['USPS_LOGIN'])
    usps_response = usps.find_rates(sender, receiver, package)
    usps_response_trimmed = usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}

    results_hash["USPS"] = usps_response_trimmed

    results_hash["USPS"].each do |line|
      method = line[0]
      cost = line[1]

      if line[2] != []
        delivery_estimate = line[2].first
      else
        delivery_estimate = nil
      end

      request.results << Result.create(price: cost, provider: "USPS", service: method, delivery_est: delivery_estimate)
    end


    fedex = ActiveShipping::FedEx.new(login: ENV['FEDEX_LOGIN'], password: ENV['FEDEX_PASSWORD'], key: ENV['FEDEX_KEY'], account: ENV['FEDEX_ACCOUNT'], test: true)
    fedex_response = fedex.find_rates(sender, receiver, package)
    fedex_response_trimmed = fedex_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}

    results_hash["Fedex"] = fedex_response_trimmed

    results_hash["Fedex"].each do |line|
      method = line[0]
      cost = line[1]

      if line[2] != []
        delivery_estimate = line[2].first
      else
        delivery_estimate = nil
      end

      request.results << Result.create(price: cost, provider: "Fedex", service: method, delivery_est: delivery_estimate)
    end

    return results_hash

  end

end

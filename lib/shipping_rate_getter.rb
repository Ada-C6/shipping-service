class ShippingRateGetter

  CARRIERS = ["UPS", "USPS", "Fedex"]

  def self.get_rates(weight, origin_zip, destination_zip, size = [12,12,12])

    ActiveShipping::USPS.logger = Logger.new('./log/logfile.log')
    ActiveShipping::UPS.logger = Logger.new('./log/logfile.log')
    ActiveShipping::FedEx.logger = Logger.new('./log/logfile.log')
    ActiveShipping::UPS.logger.level = 1
    ActiveShipping::FedEx.logger.level = 1

    package = ActiveShipping::Package.new(weight*16, size, units: :imperial)
    sender = ActiveShipping::Location.new(country: 'US', zip: origin_zip)
    receiver = ActiveShipping::Location.new(country: 'US', zip: destination_zip)

    results_hash = {}

    ups = ActiveShipping::UPS.new(login: ENV['UPS_LOGIN'], password: ENV['UPS_PASSWORD'], key: ENV['UPS_KEY'])
    ups_response = ups.find_rates(sender, receiver, package)
    ups_response_trimmed = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}
    ActiveShipping::UPS.logger.info(["UPS", origin_zip, destination_zip, package])
    ActiveShipping::UPS.logger.info(["UPS", ups_response_trimmed])

    results_hash["UPS"] = ups_response_trimmed

    usps = ActiveShipping::USPS.new(login: ENV['USPS_LOGIN'])
    usps_response = usps.find_rates(sender, receiver, package)
    usps_response_trimmed = usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}

    results_hash["USPS"] = usps_response_trimmed

    fedex = ActiveShipping::FedEx.new(login: ENV['FEDEX_LOGIN'], password: ENV['FEDEX_PASSWORD'], key: ENV['FEDEX_KEY'], account: ENV['FEDEX_ACCOUNT'], test: true)
    fedex_response = fedex.find_rates(sender, receiver, package)
    fedex_response_trimmed = fedex_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price, rate.delivery_range]}
    ActiveShipping::FedEx.logger.info(fedex_response_trimmed)

    results_hash["Fedex"] = fedex_response_trimmed

    return results_hash

  end

end

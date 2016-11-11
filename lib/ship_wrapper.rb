require 'active_shipping'
require 'timeout'
class ShipWrapper

  SELLER_ADDRESS = ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98119')
  USPS_LOGIN = ENV["USPS_USERNAME"]

  FEDEX_LOGIN = ENV["FEDEX_LOGIN"]
  FEDEX_PWD = ENV["FEDEX_PWD"]
  FEDEX_KEY = ENV["FEDEX_KEY"]
  FEDEX_ACCT = ENV["FEDEX_ACCT"]

  raise "cannot find USPS login" unless USPS_LOGIN

  def self.valid_carriers
    return ['usps', 'fedex', 'ups']
  end

  def self.is_valid_carrier?(carrier)
    return self.valid_carriers.include?(carrier)
  end

  def self.get_rates(carrier, packages, buyer_address)
    rates = []
    case carrier.downcase
    when 'usps'
      usps = ActiveShipping::USPS.new(login: USPS_LOGIN)

      response = Timeout::timeout(5) do
        usps.find_rates(SELLER_ADDRESS, buyer_address, packages)
      end
      rates = response.rates.sort_by(&:price).to_a
    when 'fedex'
      fedex = ActiveShipping::FedEx.new(login: FEDEX_LOGIN, password: FEDEX_PWD, key: FEDEX_KEY, account: FEDEX_ACCT, test: true)

      response = Timeout::timeout(10) do
        fedex.find_rates(SELLER_ADDRESS, buyer_address, packages)
      end
      rates = response.rates.sort_by(&:price).to_a
    end
    return rates #=> [["usps blah blah", 3404], ["usps overnight", 49383]]
  end


end

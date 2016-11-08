require 'httparty'
require "cgi"

class Zipcode_Api_Wrapper
  KEY = ENV["KEY"]

  #URL Format
  # https://www.zipcodeapi.com/rest/<api_key>/distance.<format>/<zip_code1>/<zip_code2>/<units>

  def self.get_distance(from, to)
    # Adding CGI::escape to santize user search inputß
    url = "https://www.zipcodeapi.com/rest/#{KEY}/distance.json/#{from.to_s}/#{to.to_s}/mile"

    response = HTTParty.get(url)
    distance = response["distance"]
    return distance
  end

end

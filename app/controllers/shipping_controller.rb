require 'active_shipping'
require 'ship_wrapper'

class ShippingController < ApplicationController
  def quote
    packages_param = params[:packages]

    unless packages_param
      # TODO return HTTP 400 Bad Request error, with message: missing 'packages' field
    end

    unless packages_param.is_a?(Array)
      # TODO return HTTP 400 Bad Request error, with message: 'packages' field must be an array of package hash
    end

    unless packages_param.length > 0
      # TODO return HTTP 400 Bad Request error, with message: 'packages' field must not be empty
    end

    packages = []
    packages_param.each do |package_param|
      unless package_param.is_a?(Hash)
        # TODO return HTTP 400 Bad Request error, with message: 'packages' field must be an array of package hash
      end

      if [:weight, :height, :length, :width].any? {|field| !package_param[field] }
        # TODO return HTTP 400 Bad Request error, with message: package hash must have 'weight', 'height', 'length', 'width'
      end

      packages << ActiveShipping::Package.new(
        package_param[:weight],
        [
          package_param[:length],
          package_param[:width],
          package_param[:height]
        ]
      )
    end

    unless buyer_country = params[:country]
      # TODO return HTTP 400 Bad Request error, with message: missing 'country' field
    end

    unless buyer_state = params[:state]
      # TODO return HTTP 400 Bad Request error, with message: missing 'state' field
    end

    unless buyer_city = params[:city]
      # TODO return HTTP 400 Bad Request error, with message: missing 'city' field
    end

    unless buyer_zip = params[:zip]
      # TODO return HTTP 400 Bad Request error, with message: missing 'zip' field
    end


=begin
    request = Request.new(
      weight: params[:weight],
      length: params[:length],
      width: params[:width],
      height:params[:height],
      buyer_country: buyer_country,
      buyer_state: buyer_state,
      buyer_city: buyer_city,
      buyer_zip: buyer_zip
    )

    request.save
=end
    # Need to be a CONSTANT. Where to put the constant?

    destination = ActiveShipping::Location.new(
      country: buyer_country,
      state: buyer_state,
      city: buyer_city,
      zip: buyer_zip)

    rates =  ShipWrapper.get_rates("usps", packages, destination)

    rates.each do |rate_array|
      Quote.create(carrier: rate_array[0], rate: rate_array[1], request_id: params[:id])
    end

    list_of_quotes = Quote.where(request_id: params[:id])


    render :json => list_of_quotes.as_json

  end
end

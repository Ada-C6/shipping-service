require 'active_shipping'
require 'ship_wrapper'
require 'json'

class ShippingController < ApplicationController
  def quote
    unless carrier = params[:carrier]
      return render :json => {:error => "must specify carrier field"}.to_json, status: :bad_request
    end

    unless ShipWrapper.is_valid_carrier?(carrier)
      return render :json => {:error => "must specify a carrier from #{ShipWrapper.valid_carriers.join(', ')}"}.to_json, status: :bad_request
    end

    packages_param = params[:packages]

    unless packages_param
      return render :json => {:error => "missing packages field"}.to_json, status: :bad_request
    end

    unless packages_param.is_a?(Array)
      return render :json => {:error => "packages field must be an array of package hash"}.to_json, status: :bad_request
    end

    unless packages_param.length > 0
      return render :json => {:error => "packages field must not be empty"}.to_json, status: :bad_request
    end

    packages = []
    packages_param.each do |package_param|
      unless package_param.is_a?(Hash)
        return render :json => {:error => "packages field must be an array of package hash"}.to_json, status: :bad_request
      end

      if [:weight, :height, :length, :width].any? {|field| !package_param[field] }
        return render :json => {:error => "package hash must have 'weight', 'height', 'length', 'width'"}.to_json, status: :bad_request
      end

      packages << ActiveShipping::Package.new(
        package_param[:weight].to_i,
        [
          package_param[:length].to_i,
          package_param[:width].to_i,
          package_param[:height].to_i
        ]
      )
    end

    unless buyer_country = params[:country]
      return render :json => {:error => "missing 'country' field"}.to_json, status: :bad_request
    end

    unless buyer_state = params[:state]
      return render :json => {:error => "missing 'state' field"}.to_json, status: :bad_request
    end

    unless buyer_city = params[:city]
      return render :json => {:error => "missing 'city' field"}.to_json, status: :bad_request
    end

    unless buyer_zip = params[:zip]
      return render :json => {:error => "missing 'zip' field"}.to_json, status: :bad_request
    end

    request = Request.create(
      packages_json: packages_param.to_json,
      buyer_country: buyer_country,
      buyer_state: buyer_state,
      buyer_city: buyer_city,
      buyer_zip: buyer_zip
    )


    destination = ActiveShipping::Location.new(
      country: buyer_country,
      state: buyer_state,
      city: buyer_city,
      zip: buyer_zip
    )

    # error handling for request does not process in a timely manner
    begin
      rates = ShipWrapper.get_rates(carrier, packages, destination)
    rescue Timeout::Error
      return render :json => {:error => "active shipper timed out"}.to_json, status: :internal_server_error
    end

    responses = []
    rates.each do |rate|
      carrier = rate.carrier
      service_name = rate.service_name
      delivery_date = rate.delivery_date
      total_price = rate.total_price

      Quote.create(
        carrier: carrier,
        rate: total_price,
        request_id: request.id
      )

      responses << {
        :carrier            => carrier,
        :service_name       => service_name,
        :cost               => total_price,
        :tracking_info      => nil,
        :delivery_estimate  => delivery_date,
      }
    end

    return render :json => responses.as_json, status: :created
  end

  private
  def shipping_params
    params.require(:request).permit(:weight, :length, :width, :height, :country, :state, :city, :zip)
  end
end

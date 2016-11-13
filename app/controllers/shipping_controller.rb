require 'active_shipping'
require 'ship_wrapper'
require 'json'

class ShippingController < ApplicationController
  def quote
    # new function below collapses all error handling into a single function rather than spreading it out within this one.
    errors = handle_input_errors(params)
    if errors
      return errors

    # if there are no errors, then we drop down and perform the function as planned.
    else
      packages_param = params[:packages]
      carrier = params[:carrier]
      # make each package into ActiveShipping package object
      packages = []
        packages_param.each do |package_param|
          packages << ActiveShipping::Package.new(
            package_param[:weight].to_i,
            [package_param[:length].to_i,
              package_param[:width].to_i,
              package_param[:height].to_i])
        end

      # make a new request in our database
      request = Request.create(
        packages_json: packages_param.to_json,
        buyer_country: params[:country],
        buyer_state: params[:state],
        buyer_city: params[:city],
        buyer_zip: params[:zip]
      )

      # make a new ActiveShipping Location object
      destination = ActiveShipping::Location.new(
        country: params[:country],
        state: params[:state],
        city: params[:city],
        zip: params[:zip]
      )

      # error handling for request does not process in a timely manner
      begin
        rates = ShipWrapper.get_rates(carrier, packages, destination)
      rescue Timeout::Error
        return render :json => {:error => "active shipper timed out"}.to_json, status: :internal_server_error
      end

      responses = []
      # with the rates returned by ActiveShipping, parse information to save in our database & render to user.
      rates.each do |rate|
        carrier = rate.carrier
        service_name = rate.service_name
        delivery_date = rate.delivery_date
        total_price = rate.total_price

        # save each shipping quote in our database
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

      # and finally, a result!
      return render :json => responses.as_json, status: :created
    end
  end

  private
  def shipping_params
    params.require(:request).permit(:weight, :length, :width, :height, :country, :state, :city, :zip)
  end

  def handle_input_errors(params)
    p_p = params[:packages]

    if !params[:carrier]
      render :json => {:error => "must specify carrier field"}.to_json, status: :bad_request
    elsif !ShipWrapper.is_valid_carrier?(params[:carrier])
      render :json => {:error => "must specify a carrier from #{ShipWrapper.valid_carriers.join(', ')}"}.to_json, status: :bad_request
    elsif !p_p
      render :json => {:error => "missing packages field"}.to_json, status: :bad_request
    elsif !p_p.is_a?(Array)
      render :json => {:error => "packages field must be an array of package hash"}.to_json, status: :bad_request
    elsif p_p.empty?
      render :json => {:error => "packages field must not be empty"}.to_json, status: :bad_request
    elsif !p_p.all? { |element| element.is_a?(Hash)  }
      render :json => {:error => "packages field must be an array of package hash"}.to_json, status: :bad_request
    elsif !check_packages_fields(p_p)
      render :json => {:error => "package hash must have 'weight', 'height', 'length', 'width'"}.to_json, status: :bad_request
    elsif !params[:country]
      render :json => {:error => "missing 'country' field"}.to_json, status: :bad_request
    elsif !params[:state]
      render :json => {:error => "missing 'state' field"}.to_json, status: :bad_request
    elsif !params[:city]
      render :json => {:error => "missing 'city' field"}.to_json, status: :bad_request
    elsif !params[:zip]
      render :json => {:error => "missing 'zip' field"}.to_json, status: :bad_request
    end
  end

  def check_packages_fields(p_p)
    p_p.each do |package|
      if [:weight, :height, :length, :width].any? {|field| !package[field] }
        return false
      else
        return true
      end
    end
  end
end

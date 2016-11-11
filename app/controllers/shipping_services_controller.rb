class ShippingServicesController < ApplicationController

  def search
    # All the shipping options for a given package/origin/destination, by calling the ShippingOption model search method.
    # TODO: After the in-class discussion, we realize that instead of passing in the specific params, we should make a query hash and strong params. Will fix if we have time.

    begin
      options = Timeout::timeout(10) { ShippingOption.search(params[:origin], params[:destination], params[:package]) }
    rescue ArgumentError, Timeout::Error => e
      if e.class == ArgumentError
        render_argument_error
      elsif e.class == Timeout::Error
        render_timeout_error
      end
        return
    end
    # if there is no ArgumentError/Timeout::Error we render the options.
    # if there is an ArugmentError/Timeout::Error, we will have returned out of the action
    render json: options

    # Logging
    create_logs
  end

  def show
    option = ShippingOption.find_by(id: params[:id])
    unless option.nil?
      # The details of a specific shipping option.
      render json: option
    else
      render nothing: true, status: :not_found
    end

    # Logging
    create_logs
  end

  private

  def render_argument_error
    render nothing: true, status: :bad_request
    create_logs
  end

  def render_timeout_error
    render nothing: true, status: :request_timeout
    create_logs
  end

  def create_logs
    logger.info(">>>>request: #{params}")

    logger.info(">>>>response: #{response.body}")
    logger.info(">>>>response_code: #{response.response_code}")
  end
end

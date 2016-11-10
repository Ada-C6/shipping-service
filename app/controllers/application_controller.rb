class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Timeout::Error, with: :handle_timeout

  protected
  def handle_timeout
    render "shared/timeout"
  end
end

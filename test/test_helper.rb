ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'vcr'
require 'webmock/minitest'
require 'simplecov'
SimpleCov.start

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  VCR.configure do |config|
    config.cassette_library_dir = 'test/cassettes' # folder where casettes will be located
    config.hook_into :webmock # tie into this other tool called webmock
    config.default_cassette_options = {
      :record => :new_episodes,    # record new data when we don't have it yet
      :match_requests_on => [:method, :uri, :body] # The http method, URI and body of a request all need to match
    }
    # Don't leave our Slack token lying around in a cassette file.
    config.filter_sensitive_data("UPS_LOGIN") do
      ENV['UPS_LOGIN']
    end
    config.filter_sensitive_data("UPS_PASSWORD") do
      ENV['UPS_PASSWORD']
    end
    config.filter_sensitive_data("UPS_KEY") do
      ENV['UPS_KEY']
    end

    config.filter_sensitive_data("USPS_LOGIN") do
      ENV['USPS_LOGIN']
    end

    config.filter_sensitive_data("FEDEX_LOGIN") do
      ENV['FEDEX_LOGIN']
    end
    config.filter_sensitive_data("FEDEX_PASSWORD") do
      ENV['FEDEX_PASSWORD']
    end
    config.filter_sensitive_data("FEDEX_KEY") do
      ENV['FEDEX_KEY']
    end
    config.filter_sensitive_data("FEDEX_ACCOUNT") do
      ENV['FEDEX_ACCOUNT']
    end
  end
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'

require 'simplecov'

require 'vcr'
require 'webmock/minitest'
SimpleCov.start
Rails.application.eager_load!

VCR.configure do |config|
  config.cassette_library_dir = 'test/cassettes' # folder where casettes will be located
  config.hook_into :webmock # tie into this other tool called webmock
  config.default_cassette_options = {
  :record => :new_episodes,    # record new data when we don't have it yet
  :match_requests_on => [:method, :uri, :body] # The http method, URI and body of a request all need to
  }
  config.filter_sensitive_data("<UPS_INFO>") do
    ENV['ACTIVESHIPPING_UPS_LOGIN']
  end

  config.filter_sensitive_data("<UPS_INFO>") do
    ENV['ACTIVESHIPPING_UPS_KEY']
  end

  config.filter_sensitive_data("<UPS_INFO>") do
    ENV['ACTIVESHIPPING_UPS_PASSWORD']
  end

  config.filter_sensitive_data("<USPS_INFO>") do
    ENV['ACTIVESHIPPING_USPS_LOGIN']
  end

end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  Minitest::Reporters.use!
end

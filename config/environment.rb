# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
YAML.load_file("#{::Rails.root}/config/env_provider.yml")[::Rails.env].each {|k,v| ENV[k] = v }
Rails.application.initialize!

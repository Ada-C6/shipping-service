# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

# this is so that we can get our manual logging to show up on heroku. 
$stdout.sync = true

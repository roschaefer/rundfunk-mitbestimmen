require 'factory_girl'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'exhaust'

ENV['RAILS_ENV'] ||= 'test'
puts Dir.pwd
root = Dir[File.dirname(File.expand_path('../../', __FILE__))].first
rails_root = File.join(root, "backend")
require File.expand_path("#{rails_root}/config/environment")




# Database Cleaner to clear out the test DB between tests
DatabaseCleaner.strategy = :truncation

Exhaust.run!
at_exit { Exhaust.shutdown! }

Capybara.configure do |config|
  # Use whatever driver you want
  config.default_driver = :poltergeist
  config.app_host = Exhaust.ember_host
end

# Shorthand FactoryGirl
include FactoryGirl::Syntax::Methods

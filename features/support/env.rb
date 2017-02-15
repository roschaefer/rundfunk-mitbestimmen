require 'factory_girl'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'capybara/cucumber'
require 'exhaust'
require 'billy/capybara/cucumber'

ENV['RAILS_ENV'] ||= 'test'
puts Dir.pwd
root = Dir[File.dirname(File.expand_path('../../', __FILE__))].first
rails_root = File.join(root, "backend")
require File.expand_path("#{rails_root}/config/environment")


# Database Cleaner to clear out the test DB between tests
DatabaseCleaner.strategy = :truncation

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.configure do |config|
  config.app_host = Exhaust.ember_host
  config.default_driver = (ENV['BROWSER'] || :selenium_chrome_billy).to_sym
end

Billy.configure do |c|
  c.cache = true
  c.persist_cache = true
  c.cache_path = 'billy'
  c.ignore_params = [
    'https://piwik.rundfunk-mitbestimmen.de/piwik.php',
    'https://cdn.eu.auth0.com/client/3NSVbVwiVABkv6uS7vRzH0sY7mqmlzOG.js',
  ]
end

Before do
  if page.driver.browser.respond_to?(:manage)
    page.driver.browser.manage.window.maximize
  end
end

After do
  Capybara.reset_sessions!
  visit '/'
  page.execute_script("localStorage.clear()")
end

# Shorthand FactoryGirl
include FactoryGirl::Syntax::Methods

Exhaust.run!
at_exit { Exhaust.shutdown! }



require 'factory_girl'
require 'active_record'
require 'childprocess'
require 'database_cleaner'
require 'active_support/dependencies'
require_relative '../../config/cukes'
require_relative './application_manager'
require 'capybara/cucumber'
require 'capybara/poltergeist'

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = Cukes.config.browser
  config.app_host = Cukes.config.host
end

# Require Models
ActiveSupport::Dependencies.autoload_paths += Dir.glob File.join(Cukes.config.rails_root, "app/models")

# Require Factories
Dir["#{Cukes.config.rails_root}/spec/factories/*.rb"].each { |f| require f }

# Connect to Test Database, suggest simply symlinking your actual database.yml from backend to config/database.yml in this project
# If you are using sqlite, you'll need a separate database.yml for this project with the relative path to the backend test.sqlite file
database_yml = File.expand_path('../../../config/database.yml', __FILE__)
if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)
  ActiveRecord::Base.configurations = active_record_configuration
  config = ActiveRecord::Base.configurations['test']
  ActiveRecord::Base.establish_connection(config)
else
  raise "Please create #{database_yml} first to configure your test database"
end

# Application Manager will start up the rails and ember apps before the suite is run and shut them down when we're finished
manager = ApplicationManager.new
manager.start_stack
at_exit do
  manager.stop_stack
end

# Database Cleaner to clear out the test DB between tests
require 'database_cleaner/cucumber'
DatabaseCleaner.strategy = :truncation
Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

# Shorthand FactoryGirl
include FactoryGirl::Syntax::Methods


Around('@de') do |scenario, block|
  locale = ENV["LANG"]
  ENV["LANG"] = 'de_DE.UTF-8'
  block.call
  ENV["LANG"] = locale
end

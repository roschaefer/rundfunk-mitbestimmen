require 'factory_girl'
require 'active_record'
require 'database_cleaner'
require 'database_cleaner/cucumber'
require 'active_support/dependencies'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'exhaust'


# Require Models
root = Dir[File.dirname(File.expand_path('../../', __FILE__))].first
rails_root = File.join(root, "backend")
ActiveSupport::Dependencies.autoload_paths += Dir.glob File.join(rails_root, "app/models")

# Require Factories
Dir["#{rails_root}/spec/factories/*.rb"].each { |f| require f }

# Connect to Test Database, suggest simply symlinking your actual database.yml from backend to config/database.yml in this project
# If you are using sqlite, you'll need a separate database.yml for this project with the relative path to the backend test.sqlite file
database_yml = File.join(rails_root, 'config', 'database.yml')
if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)
  ActiveRecord::Base.configurations = active_record_configuration
  ar_config = ActiveRecord::Base.configurations['test']
  ActiveRecord::Base.establish_connection(ar_config)
else
  raise "Please create #{database_yml} first to configure your test database"
end

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

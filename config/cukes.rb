class Cukes
  require 'active_support/configurable'
  include ActiveSupport::Configurable

  self.configure do |config|
    config.root = Dir[File.dirname(File.expand_path('../', __FILE__))].first
    config.rails_root = File.join(config.root, "backend")
    config.rails_port = 3001
    config.rails_started_message = 'Listening on'
    config.ember_root = File.join(config.root, "frontend")
    config.ember_port = 4201
    config.ember_started_message = "Build successful"
    config.host = "http://localhost:#{config.ember_port}"
    config.browser = ENV["BROWSER"] || :poltergeist
    config.startup_timeout = 20
  end

end

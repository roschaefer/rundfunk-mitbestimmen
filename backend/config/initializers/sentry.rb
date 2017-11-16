dsn = ENV['SENTRY_DSN']
if dsn
  Raven.configure do |config|
    config.dsn = dsn
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end

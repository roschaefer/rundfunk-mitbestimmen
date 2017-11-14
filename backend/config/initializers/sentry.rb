Raven.configure do |config|
  config.dsn = 'https://05936732e280480982910ff0c67aa72d:4839343d52ed46c8affc57f621206611@sentry.io/244931'
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end

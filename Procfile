backend: cd backend && bin/rails s -p $RAILS_PORT
frontend: cd frontend && ember serve -p $EMBER_PORT
sidekiq: cd backend && bundle exec sidekiq -q default -q mailers

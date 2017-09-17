require 'sidekiq/web'

Rails.application.routes.draw do
  get 'statistic/broadcasts/', to: 'statistic/broadcasts#index'
  get 'summarized_statistics/', to: 'statistics#summarized'

  resources :media, only: %i[index show]
  resources :stations, only: %i[index show]
  resources :formats
  resources :topics
  resources :broadcasts
  resources :impressions
  resources :users, only: :update
  resource  :users, only: :show

  get 'chart_data/diffs/:medium_id', to: 'chart_data#diff'
  get 'chart_data/geo/locations/', to: 'chart_data#location'
  get 'chart_data/geo/geojson/', to: 'chart_data#geojson'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])) &
        ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD']))
    end
  end
  mount Sidekiq::Web, at: '/sidekiq'
end

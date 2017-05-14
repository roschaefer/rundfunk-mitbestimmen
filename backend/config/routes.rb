Rails.application.routes.draw do
  get 'statistics/', to: 'statistics#index'
  get 'summarized_statistics/:id', to: 'statistics#summarized'

  resources :media, only: %i(index show)
  resources :stations, only: %i(index show)
  resources :formats
  resources :topics
  resources :broadcasts
  resources :selections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

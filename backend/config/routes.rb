Rails.application.routes.draw do
  get 'statistics/', to: 'statistics#index'
  get 'condensed_statistics/:id', to: 'statistics#condensed'

  resources :media, only: [:index, :show]
  resources :stations, only: [:index, :show]
  resources :formats
  resources :topics
  resources :broadcasts
  resources :selections
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

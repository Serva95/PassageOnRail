Rails.application.routes.draw do
  resources :passenger_associations
  resources :hitch_hikers
  resources :drivers
  resources :multi_trip_associations
  resources :multi_trips
  resources :single_trips
  resources :messagges
  resources :chats
  resources :routes
  resources :vehicles
  resources :ratings
  resources :reviews
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

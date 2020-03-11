Rails.application.routes.draw do
  resources :passenger_associations
  resources :hitch_hikers
  resources :drivers do
    resources :vehicles
    resources :routes, only: [:show, :edit, :update, :new, :create, :destroy] do
      get 'journey', actione: 'journey', on: :collection
    end
  end
  resources :multi_trip_associations
  resources :multi_trips
  resources :single_trips
  resources :messagges
  resources :chats
  resources :ratings
  resources :reviews
  resources :users
  resources :routes, only: :index
  get '/search' => 'routes#search'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#index'
  get 'user/login/', action: 'login', controller: 'users'

end

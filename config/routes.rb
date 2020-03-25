Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations'}
  devise_scope :user do
    get '/user/sign_out', to: 'users/sessions#destroy'
  end
  resources :passenger_associations
  resources :hitch_hikers, only: [:create, :update, :destroy]
  resources :drivers do
    resources :vehicles
    resources :routes, only: [:show, :edit, :update, :new, :create, :destroy] do
      get 'journey', action: 'journey', on: :collection
    end
  end
  resources :multi_trip_associations
  resources :multi_trips
  resources :chats, only: [:index, :show, :create, :new] do
    resources :messagges, only: [:index, :create]
  end
  resources :ratings
  resources :reviews
  resources :users, only: [:show]
  resources :searches
  resources :routes, only: [:index] do
    get 'booking', action: 'booking', on: :member
    patch 'make_booking', action: 'make_booking', on: :member
    put 'make_booking', action: 'make_booking', on: :member
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#index'

end

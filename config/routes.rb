Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations'}
  devise_scope :user do
    get '/user/sign_out', to: 'users/sessions#destroy'
  end
  resources :passenger_associations
  resources :drivers do
    resources :vehicles
    resources :routes, only: [:show, :edit, :update, :new, :create, :destroy] do
      get 'journey', action: 'journey', on: :collection
    end
  end
  resources :multi_trip_associations
  resources :multi_trips
  resources :chats, only: [:index, :show, :create, :update ,:new] do
    resources :messagges, only: [:index, :create]
  end
  resources :ratings, only: [:index, :create, :new, :destroy, :show]
  resources :reviews, only: [:index, :create, :new, :destroy, :show]
  resources :users, only: [:show]
  resources :searches
  resources :routes, only: [:index] do
    get 'booking', action: 'booking', on: :member
    patch 'make_booking', action: 'make_booking', on: :member
    put 'make_booking', action: 'make_booking', on: :member
    get 'detail', action: 'detail', on: :collection
    patch 'm_booking', action: 'make_booking', on: :collection
    put 'm_booking', action: 'make_booking', on: :collection
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#index'

end

Rails.application.routes.draw do
  devise_for :users, controllers: {sessions:'users/sessions', registrations: 'users/registrations'}
  devise_scope :user do
    get '/user/sign_out', to: 'users/sessions#destroy'
  end
  resources :journeys, only: :create
  resources :drivers do
    resources :vehicles
    resources :routes, only: [:show, :edit, :update, :new, :create, :destroy] do
      get 'journey', action: 'journey', on: :collection
    end
  end
  resources :stages, only: :create
  resources :chats, only: [:index, :show, :create, :update ,:new] do
    resources :messagges, only: [:index, :create]
  end
  resources :ratings, only: [:index, :create, :new]
  resources :reviews, only: [:index, :create, :new, :destroy]
  resources :users, only: [:show]
  resources :searches
  resources :routes, only: [:index] do
    get 'detail', action: 'detail', on: :collection
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#index'
  get '/users/:id/bookings', to: 'users#bookings', as: 'user_bookings'
end

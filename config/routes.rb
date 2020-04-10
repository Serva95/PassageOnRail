Rails.application.routes.draw do
  mount Notifications::Engine => "/notifications"
  devise_for :users, controllers: {sessions:'users/sessions', registrations: 'users/registrations'}
  devise_scope :user do
    get '/user/sign_out', to: 'users/sessions#destroy'
    get '/users/:id/bookings', to: 'users#bookings', as: 'user_bookings'
  end
  resources :journeys, only: [:create, :destroy]
  resources :drivers, only: [:new, :edit, :create, :update, :destroy] do
    get 'confirm_destroy', to: 'drivers#confirm_destroy', as: 'confirm_destroy'
    resources :vehicles
    resources :routes
  end
  resources :stages, only: :create
  resources :chats, only: [:index, :create, :destroy] do
    resources :messagges, only: [:index, :create]
  end
  resources :ratings, only: [:index, :create, :new]
  resources :reviews, only: [:index, :create, :new, :destroy]
  resources :users, only: [:show]
  resources :searches
  resources :routes, only: [] do
    get 'detail', action: 'detail', on: :collection
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#index'
end

Rails.application.routes.draw do

  devise_for :users, controllers: {sessions:'users/sessions', registrations: 'users/registrations',
                                   passwords:'users/passwords', confirmations: 'users/confirmations'}
  devise_scope :user do
    get '/user/sign_out', to: 'users/sessions#destroy'
    get '/users/:id/bookings', to: 'users#bookings', as: 'user_bookings'
    get '/users/:id/manage_booking_delete', to: 'journeys#manage_booking_delete', as: 'user_manage_booking_delete'
    get '/users/:id/manage_booking_update', to: 'journeys#manage_booking_update', as: 'user_manage_booking_update'
    get '/users/:id/bookings/detail', to: 'users#detail_booking', as: 'user_detail_booking'
  end
  resources :journeys, only: [:create, :destroy, :new]
  resources :drivers, only: [:new, :edit, :create, :update, :destroy] do
    get 'confirm_destroy', to: 'drivers#confirm_destroy', as: 'confirm_destroy'
    resources :vehicles
    resources :routes
    resources :journeys, only: [:index]
    resources :stages, only: :update
  end
  resources :stages, only: [:create, :destroy]
  resources :chats, only: [:index, :create, :destroy] do
    resources :messagges, only: [:index, :create]
  end
  resources :ratings, only: [:index, :create, :new]
  resources :reviews, only: [:index, :create, :new, :destroy]
  resources :users, only: [:show] do
    resources :pay_methods
  end
  resources :searches
  resources :routes, only: [] do
    get 'detail', action: 'detail', on: :collection
    resources :journeys, only: [:edit, :update] do
    end
  end

  resources :notifications do
    collection do
      post :mark_as_read
    end
  end
  get "/404", :to => "errors#not_found"
  get "/442", :to => "errors#record_not_found"
  get "/500", :to => "errors#internal_server_error"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#index'
  get '/users/:id/pay_methods/', to: 'pay_method#index',  as: 'user_pay_methods_index'
end

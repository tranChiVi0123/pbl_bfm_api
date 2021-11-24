# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    devise_for :users, class: "User" ,controllers: { 
      :registrations => "api/users/registrations",
      :sessions      => "api/users/sessions"
     }
    
    namespace :accounts do
      resources :aggregations, only: [:create]
    end

    resources :accounts, only: [:index]
    resources :transactions, only: [:index]
  end

  get "list_otp", to: "home#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

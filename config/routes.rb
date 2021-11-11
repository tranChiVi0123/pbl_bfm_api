# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    devise_for :users, class: "User" ,controllers: { 
      :registrations => "api/users/registrations",
      :sessions      => "api/users/sessions"
     }
  end

  get "home", to: "home#show"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

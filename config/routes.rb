# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root to: 'home#index'

  resources :home
  resources :explore
  resources :search
  resources :tweets do
    member { get :retweets }
  end
  resources :users do
    member do
      get :followers
      get :followees
      get :profile
    end
  end
  resources :follows
  resources :retweets
end

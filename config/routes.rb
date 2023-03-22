# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root 'tweets#index'

  resources :tweets do
    collection do
      get 'explore'
    end
    member do
      get 'retweets'
    end
  end
  resources :users do
    member do
      get 'followers'
      get 'followees'
      get 'profile'
    end
  end
  resources :follows
  resources :retweets
end

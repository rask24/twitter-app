Rails.application.routes.draw do
  get 'follows/create'
  get 'users/show'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "tweets#index"

  resources :tweets
  resources :users
  resources :follows
  resources :retweets

end

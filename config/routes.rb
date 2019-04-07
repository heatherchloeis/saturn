Rails.application.routes.draw do
  root 'application#home'

  get '/about',				to: "application#about"
  get '/contact',			to: "application#contact"
  get '/livestream', 	to: "application#live_stream"
  get '/login',				to: "sessions#new"
  post '/login',			to: "sessions#create"
  delete '/logout',		to: "sessions#destroy"

  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
end
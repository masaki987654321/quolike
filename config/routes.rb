Rails.application.routes.draw do
  root 'home_pages#home'
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  resources :users
  resources :questions, only: [:new, :show, :create, :destroy] 
  resources :answers, only: [:new, :create, :destroy]
end

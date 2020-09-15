Rails.application.routes.draw do
  root 'questions#solved_index'
  get '/questions/unsolved_index' => 'questions#unsolved_index', as: 'unsolved_questions'
  get '/signup' => 'users#new'
  post '/signup' => 'users#create'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  patch 'designate_best_answer' => 'questions#designate_best_answer', as: 'designate_best_answer'
  resources :users
  resources :questions, only: [:new, :show, :create, :update, :destroy] 
  resources :answers, only: [:new, :create, :destroy]
end

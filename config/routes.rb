# frozen_string_literal: true

Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get '/summary', :to => 'daily_logs#summary', as: 'summary'
  post 'daily_logs/new', :to =>'daily_logs#new'
  get 'daily_logs/people_logs', :to => 'daily_logs#people_logs', as: 'people_logs'
  post 'daily_logs/refresh', :to => 'daily_logs#refresh'
  get 'daily_logs/user_list', :to => 'daily_logs#user_list'
  match 'daily_logs/user_logs', :to => 'daily_logs#user_logs', via:[:GET,:POST]
  match 'daily_logs/edit_log', :to => 'daily_logs#edit_log', via:[:GET,:POST],as:'edit_log'
  match 'daily_logs/update', :to =>'daily_logs#update',via: [:POST], as:'update'

  resources :sessions, only: [:create, :destroy]
  resources :daily_logs, only: [:new, :create]
  # resources :daily_logs do
  #   get "/daily_logs/new", on: :collection 
  # end
  resources :projects

  root :to => 'daily_logs#index'
end

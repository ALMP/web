# frozen_string_literal: true
require 'sidekiq/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  post '/translate' => 'translate#index'
  get '/about' => 'pages#about', id: :about
  get '/contacts' => 'pages#contacts', id: :contacts
  get '/why_we' => 'pages#why_we', id: :why_we
  get '/how_it_works' => 'pages#how_it_works', id: :how_it_works
  get '/guidlines' => 'pages#guidlines', id: :guidlines
  get '/privacy' => 'pages#privacy', id: :privacy
  get '/terms' => 'pages#terms', id: :terms
  get '/index' => 'pages#index', id: :index

  resources :companies, only: %i(index show new create) do
    resources :reviews, only: :index
    resources :purchase_prices, only: :index
    resources :publications, only: :index
  end
  resources :purchase_prices, only: %i(new create)
  resources :categories, only: %i(show index) do
    resources :goods, only: :index, controller: 'categories/goods'
  end
  resources :goods, only: %i(show index)
  resources :reviews, only: %i(new create show edit update)
  resources :users, only: %i() do
    resources :reviews, controller: 'users/reviews', only: :index
    resources :purchase_prices, controller: 'users/purchase_prices', only: :index
  end
  resources :faqs, only: 'index'
  resources :publications, only: %i(new create show edit update)
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  namespace :api do
    api_version module: 'V1', path: { value: 'v1' } do
      resources :categories, only: %i(index)
      resources :goods, only: %i(index)
      resources :cities, only: %i(index)
      resources :companies, only: %i(index)
      resources :users, only: %i(index)
    end
  end

  namespace :admin do
    resources :companies
    resources :goods
    resources :categories
    resources :cities
    resources :users
    resources :custom_ratings, except: [:new, :create]
    resources :company_aliases
    resources :reviews do
      patch :approve
      patch :decline
    end
    resources :purchase_prices do
      patch :approve
      patch :decline
    end
    resources :faqs
    resources :publications
    root to: 'companies#index'

    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'pages#index'
end

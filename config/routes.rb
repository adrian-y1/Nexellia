Rails.application.routes.draw do
  devise_for :users

  resources :posts do
    resources :comments, only: [:create, :destroy] do
      post 'like', to: 'comments#like', as: 'like'
    end
    post 'like', to: 'posts#like', as: 'like'
  end

  resources :comments, only: [:create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show] do
    resources :profiles, only: [:edit, :update]
    resources :friend_requests, only: [:create, :destroy]
    resources :friendships, only: [:create, :destroy]
  end

  resources :notifications, only: [:index]

  root 'posts#index'
end

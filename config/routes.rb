Rails.application.routes.draw do
  devise_for :users

  resources :posts do
    resources :comments, only: [:new, :create, :destroy]
    post 'like', to: 'posts#like', as: 'like'
  end

  resources :users, only: [:index] do
    resources :friend_requests, only: [:create, :destroy]
    resources :friendships, only: [:create, :destroy]
  end

  root 'posts#index'
end

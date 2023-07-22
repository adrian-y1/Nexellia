Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :posts do
    resources :comments, only: [:index, :create, :destroy] do
      post 'like', to: 'comments#like', as: 'like'
    end
    post 'like', to: 'posts#like', as: 'like'
  end

  resources :comments, only: [:index, :create, :destroy] do
    resources :comments, only: [:index, :create, :destroy]
  end

  resources :users, only: [:index, :show] do
    get 'friends'
    resources :profiles, only: [:edit, :update]
    resources :friend_requests, only: [:create, :destroy]
    resources :friendships, only: [:create, :destroy]
  end

  resources :search, only: [:index]

  resources :notifications, only: [:index, :update] do
    collection do
      get :destroy_all
    end
  end
  
  resources :privacy_policy, only: [:index]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  
  root 'posts#index'
end

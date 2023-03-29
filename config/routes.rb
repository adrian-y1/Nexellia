Rails.application.routes.draw do
  devise_for :users

  resources :posts do
    resources :comments, only: [:new, :create, :destroy]
    post 'like', to: 'posts#like', as: 'like'
  end

  resources :users, only: [:index]

  root 'posts#index'
end

Rails.application.routes.draw do
  devise_for :users

  resources :posts do
    resources :comments, only: [:new, :create, :destroy]
    post 'like', to: 'posts#like', as: 'like'
  end

  root 'posts#index'
end

Rails.application.routes.draw do
  resources :items do
    resources :purchase_requests, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end
  get 'listed_items', to: "listed_items#index"
  get 'requested_items', to: "requested_items#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  authenticated do
    root to: "items#index", as: :authenticated_root
  end

  root to: "welcome#index"
end

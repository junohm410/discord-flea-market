Rails.application.routes.draw do
  namespace :api do
    get :health, to: 'health#index'
    namespace :v1 do
      # 後続でコントローラを実装
    end
  end

  resources :items do
    resources :purchase_requests, only: [:create, :destroy]
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :users, only: [:destroy]

  get 'listed_items', to: "listed_items#index"
  get 'requested_items', to: "requested_items#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  authenticated do
    root to: "items#index", as: :authenticated_root
  end

  get '/withdraw', to: 'withdrawals#new'

  root to: "welcome#index"
end

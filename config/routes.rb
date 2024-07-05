Rails.application.routes.draw do
  resources :items do
    resources :purchase_requests, only: [:create, :destroy]
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  root to: "welcome#index"
end

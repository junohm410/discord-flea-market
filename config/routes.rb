Rails.application.routes.draw do
  # TODO: 仮のログイン後のページに遷移するための実装。他のitemsリソースを追加した際に修正する。
  get '/items', to: 'items#index', as: :items

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  root to: "welcome#index"
end

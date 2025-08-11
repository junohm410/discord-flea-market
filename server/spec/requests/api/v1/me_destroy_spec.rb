# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/me', type: :request do
  let!(:user) { create(:user) }

  context 'ログイン済みの場合' do
    it '204 No Content を返し、ユーザーを削除してセッションを破棄する' do
      sign_in user

      expect { delete '/api/v1/me' }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)

      get '/api/v1/me'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context '未ログインの場合' do
    it '401 を返す' do
      delete '/api/v1/me'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

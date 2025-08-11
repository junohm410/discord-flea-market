# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DELETE /api/v1/session', type: :request do
  let(:user) { create(:user) }

  context 'ログイン済みの場合' do
    it '204 No Content を返し、セッションを破棄する' do
      sign_in user

      delete '/api/v1/session'

      expect(response).to have_http_status(:no_content)
    end

    it 'ログアウト後は /api/v1/me が 401 を返す' do
      sign_in user

      # 事前確認：ログイン中は 200
      get '/api/v1/me'
      expect(response).to have_http_status(:ok)

      # ログアウト
      delete '/api/v1/session'

      # 以降は未認証として 401
      get '/api/v1/me'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context '未ログインの場合' do
    it '401 を返す（API は JSON 固定でリダイレクトしない）' do
      delete '/api/v1/session'

      expect(response).to have_http_status(:unauthorized)
    end
  end
end

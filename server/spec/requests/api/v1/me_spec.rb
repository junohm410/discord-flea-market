# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GET /api/v1/me', type: :request do
  describe '認証必須' do
    let(:user) { create(:user) }

    context 'ログイン済みの場合' do
      it '200 とユーザー情報を返す' do
        sign_in user

        get '/api/v1/me'

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(user.id)
        expect(json['name']).to eq(user.name)
        expect(json['avatarUrl']).to eq(user.avatar_url)
      end
    end

    context '未ログインの場合' do
      it '401 を返す（API は JSON 固定でリダイレクトしない）' do
        get '/api/v1/me'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

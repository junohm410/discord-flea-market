# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Comments のAPI', type: :request do
  let(:user) { create(:user) }
  let(:item) { create(:item, user: create(:user), status: :listed) }

  before { sign_in user }

  describe 'GET /api/v1/items/:item_id/comments（一覧）' do
    it 'ページネーション付きで返す' do
      create_list(:comment, 3, item:, user: create(:user))
      get "/api/v1/items/#{item.id}/comments", params: { page: 1, per: 2 }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']).to be_an(Array)
      expect(json['data'].length).to eq 2
      expect(json['meta']).to include('total', 'totalPages', 'currentPage', 'per')
    end
  end

  describe 'POST /api/v1/items/:item_id/comments（作成）' do
    it 'コメントを作成し、201で返す（DBに作成される）' do
      expect do
        post "/api/v1/items/#{item.id}/comments", params: { comment: { content: 'こんにちは' } }
      end.to change(Comment, :count).by(1)
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json).to include('id', 'content', 'author')
      expect(json['content']).to eq 'こんにちは'
    end

    it 'バリデーションエラーで422を返す' do
      post "/api/v1/items/#{item.id}/comments", params: { comment: { content: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/v1/items/:item_id/comments/:id（更新）' do
    it '自分のコメントを更新できる（DB更新される）' do
      comment = create(:comment, item:, user:, content: 'old')
      patch "/api/v1/items/#{item.id}/comments/#{comment.id}", params: { comment: { content: 'new' } }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['content']).to eq 'new'
      expect(comment.reload.content).to eq 'new'
    end

    it '他人のコメントは更新できない（404）' do
      other_comment = create(:comment, item:, user: create(:user), content: 'x')
      patch "/api/v1/items/#{item.id}/comments/#{other_comment.id}", params: { comment: { content: 'y' } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/items/:item_id/comments/:id（削除）' do
    it '自分のコメントを削除できる（204、DBから削除）' do
      comment = create(:comment, item:, user:, content: 'bye')
      expect do
        delete "/api/v1/items/#{item.id}/comments/#{comment.id}"
      end.to change(Comment, :count).by(-1)
      expect(response).to have_http_status(:no_content)
      expect(Comment.where(id: comment.id)).to be_empty
    end
  end
end

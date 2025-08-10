# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Items のAPI', type: :request do
  let(:user) { create(:user) }

  describe 'GET /api/v1/items（一覧）' do
    before do
      create_list(:item, 15, status: :listed, user: create(:user))
    end

    it 'ページネーション付きで一覧を返す' do
      get '/api/v1/items', params: { page: 1, per: 12 }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq 12
      expect(json['meta']).to include('total', 'totalPages', 'currentPage', 'per', 'hasPrev', 'hasNext')
      expect(json['meta']['total']).to eq 15
      expect(json['meta']['totalPages']).to eq 2
      expect(json['meta']['currentPage']).to eq 1
      expect(json['meta']['per']).to eq 12
      expect(json['meta']['hasPrev']).to be false
      expect(json['meta']['hasNext']).to be true
    end
  end

  describe 'GET /api/v1/items/:id（詳細）' do
    it 'seller と imageUrls を含む商品を返す' do
      user = create(:user)
      item = create(:item, status: :listed, user:)
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec/files/book.png'), 'image/png')
      item.images.attach(file)

      get "/api/v1/items/#{item.id}"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']).to include('id', 'title', 'description', 'price', 'status', 'deadline', 'seller', 'imageUrls')
      expect(json['data']['id']).to eq item.id
      expect(json['data']['title']).to eq item.name
      expect(json['data']['seller']).to include('name' => user.name, 'avatarUrl' => user.avatar_url)
      expect(json['data']['imageUrls']).to be_an(Array)
      expect(json['data']['imageUrls'].first).to include('/rails/active_storage')
    end
  end

  describe 'POST /api/v1/items（作成）' do
    before { sign_in user }

    let(:valid_params) do
      {
        item: {
          name: '新規アイテム',
          description: '説明',
          price: 1200,
          shipping_cost_covered: true,
          payment_method: 'PayPay',
          deadline: Time.zone.tomorrow,
          status: 'listed'
        }
      }
    end

    it '認証済みなら作成でき、201で返る' do
      post '/api/v1/items', params: valid_params
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['data']['title']).to eq '新規アイテム'
    end
  end

  describe 'PATCH /api/v1/items/:id（更新）' do
    before { sign_in user }

    it '所有者なら更新できる' do
      item = create(:item, user:, status: :listed)
      patch "/api/v1/items/#{item.id}", params: { item: { description: '更新後' } }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['description']).to eq '更新後'
    end

    it '他人のアイテムは更新できない（404）' do
      other = create(:user)
      item = create(:item, user: other, status: :listed)
      patch "/api/v1/items/#{item.id}", params: { item: { description: 'NG' } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/items/:id（削除）' do
    before { sign_in user }

    it '所有者なら削除でき、204で返る' do
      item = create(:item, user:, status: :listed)
      delete "/api/v1/items/#{item.id}"
      expect(response).to have_http_status(:no_content)
      expect(Item.where(id: item.id)).to be_empty
    end
  end
end

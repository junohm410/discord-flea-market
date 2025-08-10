# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Items のAPI', type: :request do
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
end

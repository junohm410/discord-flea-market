# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::PurchaseRequests のAPI', type: :request do
  let(:user) { create(:user) }
  let(:seller) { create(:user) }
  let(:item) { create(:item, user: seller, status: :listed) }

  before { sign_in user }

  describe 'POST /api/v1/items/:item_id/purchase_requests（トグルON）' do
    it '購入希望を作成し、201で item を返す（DBに作成される）' do
      expect do
        post "/api/v1/items/#{item.id}/purchase_requests"
      end.to change(PurchaseRequest, :count).by(1)
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['id']).to eq item.id
    end
  end

  describe 'DELETE /api/v1/items/:item_id/purchase_requests/:id（トグルOFF）' do
    it '自分の購入希望を削除し、200で item を返す（DBから削除）' do
      pr = user.purchase_requests.create!(item:)
      expect do
        delete "/api/v1/items/#{item.id}/purchase_requests/#{pr.id}"
      end.to change(PurchaseRequest, :count).by(-1)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq item.id
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Me::ListedItems のAPI', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /api/v1/me/listed_items' do
    context 'when status=listed のとき' do
      let!(:my_listed) { create(:item, user:, status: :listed) }

      before do
        create(:item, user:, status: :unpublished)
        create(:item, user:, status: :buyer_selected)
        create(:item, user: create(:user), status: :listed)
      end

      it '自分の listed のみ返す' do
        get '/api/v1/me/listed_items', params: { page: 1, per: 12, status: 'listed' }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        ids = json['data'].map { |x| x['id'] }
        expect(ids).to contain_exactly(my_listed.id)
        expect(json['meta']).to include('total', 'totalPages', 'currentPage', 'per')
      end
    end

    context 'when status を指定しないとき' do
      let!(:my_listed) { create(:item, user:, status: :listed) }
      let!(:my_unpublished) { create(:item, user:, status: :unpublished) }
      let!(:my_buyer_selected) { create(:item, user:, status: :buyer_selected) }
      let!(:other_listed) { create(:item, user: create(:user), status: :listed) }

      it '自分の全件のみ返し、他人は含まない' do
        get '/api/v1/me/listed_items', params: { page: 1, per: 12 }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        ids = json['data'].map { |x| x['id'] }
        expect(ids).to contain_exactly(my_listed.id, my_unpublished.id, my_buyer_selected.id)
        expect(ids).not_to include(other_listed.id)
      end
    end

    context 'when status=unpublished のとき' do
      let!(:my_unpublished) { create(:item, user:, status: :unpublished) }

      before do
        create(:item, user:, status: :listed)
        create(:item, user:, status: :buyer_selected)
        create(:item, user: create(:user), status: :unpublished)
      end

      it '自分の unpublished のみ返す' do
        get '/api/v1/me/listed_items', params: { page: 1, per: 12, status: 'unpublished' }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        ids = json['data'].map { |x| x['id'] }
        expect(ids).to contain_exactly(my_unpublished.id)
      end
    end

    context 'when status=buyer_selected のとき' do
      let!(:my_buyer_selected) { create(:item, user:, status: :buyer_selected) }

      before do
        create(:item, user:, status: :listed)
        create(:item, user:, status: :unpublished)
        create(:item, user: create(:user), status: :buyer_selected)
      end

      it '自分の buyer_selected のみ返す' do
        get '/api/v1/me/listed_items', params: { page: 1, per: 12, status: 'buyer_selected' }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        ids = json['data'].map { |x| x['id'] }
        expect(ids).to contain_exactly(my_buyer_selected.id)
      end
    end
  end
end

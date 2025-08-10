# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Me::RequestedItems のAPI', type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET /api/v1/me/requested_items' do
    context 'when status=requested のとき' do
      let!(:requested_item) { create(:item, status: :listed, user: create(:user)) }

      before { user.purchase_requests.create!(item: requested_item) }

      it '自分がリクエストした listed のみ返す' do
        get '/api/v1/me/requested_items', params: { page: 1, per: 12, status: 'requested' }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data'].map { |x| x['id'] }).to contain_exactly(requested_item.id)
      end
    end

    context 'when status=selected_as_buyer のとき' do
      let!(:selected_me) { create(:item, status: :buyer_selected, buyer: user, user: create(:user)) }

      before { user.purchase_requests.create!(item: selected_me) }

      it '自分が買い手に選ばれた item のみ返す' do
        get '/api/v1/me/requested_items', params: { page: 1, per: 12, status: 'selected_as_buyer' }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data'].map { |x| x['id'] }).to contain_exactly(selected_me.id)
      end
    end

    context 'when status=not_selected のとき' do
      let!(:not_selected) { create(:item, status: :buyer_selected, buyer: create(:user), user: create(:user)) }

      before { user.purchase_requests.create!(item: not_selected) }

      it '自分が買い手に選ばれていない item のみ返す' do
        get '/api/v1/me/requested_items', params: { page: 1, per: 12, status: 'not_selected' }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['data'].map { |x| x['id'] }).to contain_exactly(not_selected.id)
      end
    end

    context 'when status を指定しないとき' do
      let!(:requested_item) { create(:item, status: :listed, user: create(:user)) }
      let!(:selected_me) { create(:item, status: :buyer_selected, buyer: user, user: create(:user)) }
      let!(:not_selected) { create(:item, status: :buyer_selected, buyer: create(:user), user: create(:user)) }
      let!(:not_requested) { create(:item, status: :listed, user: create(:user)) }

      before do
        user.purchase_requests.create!(item: requested_item)
        user.purchase_requests.create!(item: selected_me)
        user.purchase_requests.create!(item: not_selected)
      end

      it '自分が関与した item のみ返す（未リクエストは含まない）' do
        get '/api/v1/me/requested_items', params: { page: 1, per: 12 }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        ids = json['data'].map { |x| x['id'] }
        expect(ids).to include(requested_item.id, selected_me.id, not_selected.id)
        expect(ids).not_to include(not_requested.id)
      end
    end
  end
end

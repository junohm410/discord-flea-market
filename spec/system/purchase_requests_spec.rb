# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PurchaseRequests', type: :system do
  let(:alice) { FactoryBot.create(:user) }
  let(:bob) { FactoryBot.create(:user, name: 'bob') }
  let(:carol) { FactoryBot.create(:user, name: 'carol') }
  let(:item) { FactoryBot.create(:item, user: bob) }

  it 'user can create a purchase request' do
    sign_in alice
    visit item_path(item)
    expect do
      click_button '購入希望を出す'
      expect(page).to have_content '購入希望を出しました'
    end.to change { item.purchase_requests.count }.from(0).to(1)
    expect(page).to have_content '購入希望を出しています'
    expect(page).not_to have_button '購入希望を出す'
  end

  it 'user can cancel a purchase request' do
    FactoryBot.create(:purchase_request, user: alice, item:)
    sign_in alice
    visit item_path(item)
    expect do
      click_button '購入希望を取り消す'
      expect(page).to have_content '購入希望を取り消しました'
    end.to change { item.purchase_requests.count }.from(1).to(0)
    expect(page).to have_button '購入希望を出す'
  end

  context 'when a buyer for an item has already been selected' do
    it "user can't create a purchase request" do
      selected_as_buyer_item = FactoryBot.create(:buyer_selected_item, user: bob, buyer: alice)
      FactoryBot.create(:purchase_request, item: selected_as_buyer_item, user: alice)
      not_selected_as_buyer_item = FactoryBot.create(:buyer_selected_item, user: bob, buyer: carol)
      FactoryBot.create(:purchase_request, item: not_selected_as_buyer_item, user: alice)
      just_selection_finished_item = FactoryBot.create(:buyer_selected_item, user: bob, buyer: carol)

      sign_in alice
      visit item_path(selected_as_buyer_item)
      expect(page).not_to have_button '購入希望を出す'
      visit item_path(not_selected_as_buyer_item)
      expect(page).not_to have_button '購入希望を出す'
      visit item_path(just_selection_finished_item)
      expect(page).not_to have_button '購入希望を出す'
    end
  end

  context 'when user checks an item between its deadline and lottery' do
    let(:closed_yesterday_item) { FactoryBot.create(:closed_yesterday_and_not_buyer_selected_item, user: alice) }

    it "user can see a label about waiting for lottery and can't create a purchase request" do
      sign_in bob
      visit item_path(closed_yesterday_item)
      expect(page).to have_content '購入者の抽選待ちです'
      expect(page).not_to have_button '購入希望を出す'
    end

    context 'when user checks their requesting item between its deadline and lottery' do
      it "user can see a label about waiting for lottery and can't cancel a purchase request" do
        FactoryBot.create(:purchase_request, user: bob, item: closed_yesterday_item)

        sign_in bob
        visit item_path(closed_yesterday_item)
        expect(page).to have_content '購入者の抽選待ちです'
        expect(page).to have_content '購入希望を出しています'
        expect(page).not_to have_button '購入希望を取り消す'
      end
    end
  end
end

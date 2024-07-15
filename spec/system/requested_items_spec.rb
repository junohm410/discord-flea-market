# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RequestedItems', type: :system do
  let(:alice) { FactoryBot.create(:user) }
  let(:bob) { FactoryBot.create(:user, name: 'bob') }
  let(:carol) { FactoryBot.create(:user, name: 'carol') }

  before do
    currently_requesting_item = FactoryBot.create(:item, name: '購入希望中の商品', user: bob)
    FactoryBot.create(:purchase_request, item: currently_requesting_item, user: alice)
    selected_as_buyer_item = FactoryBot.create(:buyer_selected_item, name: '購入確定の商品', user: bob, buyer: alice)
    FactoryBot.create(:purchase_request, item: selected_as_buyer_item, user: alice)
    not_selected_as_buyer_item = FactoryBot.create(:buyer_selected_item, name: '落選の商品', user: bob, buyer: carol)
    FactoryBot.create(:purchase_request, item: not_selected_as_buyer_item, user: alice)
  end

  it 'user can check all of their requesting items' do
    sign_in alice
    visit requested_items_path
    expect(page).to have_content '購入希望中の商品'
    expect(page).to have_content '購入確定の商品'
    expect(page).to have_content '落選の商品'
  end

  it 'user can filter items by status' do
    sign_in alice
    visit requested_items_path
    click_on '購入希望中'
    expect(page).to have_content '購入希望中の商品'
    expect(page).not_to have_content '購入確定の商品'
    expect(page).not_to have_content '落選の商品'

    click_on '購入確定'
    expect(page).not_to have_content '購入希望中の商品'
    expect(page).to have_content '購入確定の商品'
    expect(page).not_to have_content '落選の商品'

    click_on '落選'
    expect(page).not_to have_content '購入希望中の商品'
    expect(page).not_to have_content '購入確定の商品'
    expect(page).to have_content '落選の商品'
  end
end

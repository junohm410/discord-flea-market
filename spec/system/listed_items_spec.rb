# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ListedItems', type: :system do
  let(:alice) { FactoryBot.create(:user) }
  let(:bob) { FactoryBot.create(:user, name: 'bob') }

  before do
    FactoryBot.create(:item, name: '出品中の商品', user: alice)
    FactoryBot.create(:unpublished_item, name: '非公開の商品', user: alice)
    FactoryBot.create(:buyer_selected_item, name: '購入者確定の商品', user: alice, buyer: bob)
  end

  it 'user can check all of their own items' do
    sign_in alice
    visit listed_items_path
    expect(page).to have_content '出品中の商品'
    expect(page).to have_content '非公開の商品'
    expect(page).to have_content '購入者確定の商品'
  end

  it 'user can filter items by status' do
    sign_in alice
    visit listed_items_path
    click_on '出品中'
    expect(page).to have_content '出品中の商品'
    expect(page).not_to have_content '非公開の商品'
    expect(page).not_to have_content '購入者確定の商品'

    click_on '非公開'
    expect(page).not_to have_content '出品中の商品'
    expect(page).to have_content '非公開の商品'
    expect(page).not_to have_content '購入者確定の商品'

    click_on '購入者確定'
    expect(page).not_to have_content '出品中の商品'
    expect(page).not_to have_content '非公開の商品'
    expect(page).to have_content '購入者確定の商品'
  end
end

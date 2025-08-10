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

  it 'user can check all of their requesting items attached with images' do
    currently_requesting_item = Item.find_by(name: '購入希望中の商品')
    selected_as_buyer_item = Item.find_by(name: '購入確定の商品')
    not_selected_as_buyer_item = Item.find_by(name: '落選の商品')
    currently_requesting_item.images.attach(io: File.open(Rails.root.join('spec/files/book.png')), filename: 'book.png')
    currently_requesting_item.images.attach(io: File.open(Rails.root.join('spec/files/books.png')), filename: 'books.png')
    selected_as_buyer_item.images.attach(io: File.open(Rails.root.join('spec/files/books.png')), filename: 'books.png')

    sign_in alice
    visit requested_items_path

    within "#requested_item_container_#{currently_requesting_item.id}" do
      expect(page).to have_content '購入希望中の商品'
      expect(page).to have_selector("img[src$='book.png']")
      expect(page).not_to have_selector("img[src$='books.png']")
    end
    within "#requested_item_container_#{selected_as_buyer_item.id}" do
      expect(page).to have_content '購入確定の商品'
      expect(page).to have_selector("img[src$='books.png']")
    end
    within "#requested_item_container_#{not_selected_as_buyer_item.id}" do
      expect(page).to have_content '落選の商品'
      expect(page).to have_selector("img[src*='no_image']")
    end
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

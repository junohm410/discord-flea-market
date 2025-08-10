# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ListedItems', type: :system do
  let(:alice) { FactoryBot.create(:user) }
  let(:bob) { FactoryBot.create(:user, name: 'bob') }
  let!(:listed_item) { FactoryBot.create(:item, name: '出品中の商品', user: alice) }
  let!(:unpublished_item) { FactoryBot.create(:unpublished_item, name: '非公開の商品', user: alice) }
  let!(:buyer_selected_item) { FactoryBot.create(:buyer_selected_item, name: '購入者確定の商品', user: alice, buyer: bob) }

  it 'user can check all of their own items attached with images' do
    listed_item.images.attach(io: File.open(Rails.root.join('spec/files/book.png')), filename: 'book.png')
    listed_item.images.attach(io: File.open(Rails.root.join('spec/files/books.png')), filename: 'books.png')
    unpublished_item.images.attach(io: File.open(Rails.root.join('spec/files/books.png')), filename: 'books.png')

    sign_in alice
    visit listed_items_path

    within "#listed_item_container_#{listed_item.id}" do
      expect(page).to have_content '出品中の商品'
      expect(page).to have_selector("img[src$='book.png']")
      expect(page).not_to have_selector("img[src$='books.png']")
    end
    within "#listed_item_container_#{unpublished_item.id}" do
      expect(page).to have_content '非公開の商品'
      expect(page).to have_selector("img[src$='books.png']")
    end
    within "#listed_item_container_#{buyer_selected_item.id}" do
      expect(page).to have_content '購入者確定の商品'
      expect(page).to have_selector("img[src*='no_image']")
    end
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

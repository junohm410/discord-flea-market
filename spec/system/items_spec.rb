# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Items', type: :system do
  let(:alice) { FactoryBot.create(:user) }
  let(:bob) { FactoryBot.create(:user, name: 'bob') }
  let(:carol) { FactoryBot.create(:user, name: 'carol') }

  describe 'listing items' do
    it 'user can list an item' do
      expect(DiscordNotifier).to receive_message_chain(:with, :item_listed, :notify_now) # rubocop:disable RSpec/MessageChain

      sign_in alice
      visit items_path
      click_on '商品を出品する'
      fill_in '商品名', with: 'テスト商品'
      fill_in '価格', with: 1000
      fill_in '商品の説明', with: 'テスト商品です'
      check '送料の負担'
      fill_in '希望する支払方法', with: 'PayPay'
      fill_in '購入希望の締切日', with: Time.zone.tomorrow
      attach_file '商品画像', [
        Rails.root.join('spec/files/book.png'),
        Rails.root.join('spec/files/books.png')
      ]
      click_on '出品する'
      expect(page).to have_content 'Item was successfully created.'
      expect(page).to have_content 'テスト商品'
      expect(page).to have_selector("img[src$='book.png']")
      find('.splide__arrow.splide__arrow--next').click
      expect(page).to have_selector("img[src$='books.png']")
    end

    it 'user can save an item as unpublished' do
      allow(DiscordNotifier).to receive(:with)
      allow(DiscordNotifier).to receive(:item_listed)

      sign_in alice
      visit items_path
      click_on '商品を出品する'
      fill_in '商品名', with: '非公開商品'
      fill_in '商品の説明', with: '非公開商品です'
      fill_in '価格', with: 1000
      check '送料の負担'
      fill_in '希望する支払方法', with: 'PayPay'
      fill_in '購入希望の締切日', with: Time.zone.tomorrow
      click_on '非公開として保存'
      expect(page).to have_content 'Item was successfully created.'
      expect(page).to have_content 'この商品は非公開です'
      expect(DiscordNotifier).not_to have_received(:with)
      expect(DiscordNotifier).not_to have_received(:item_listed)
    end

    context 'when validation errors occur in non-image columns while attaching images' do
      it 'user can see an edit form again with messages about validation errors' do
        sign_in alice
        visit new_item_path
        fill_in '価格', with: 1000
        fill_in '商品の説明', with: 'テスト商品です'
        fill_in '購入希望の締切日', with: Time.zone.tomorrow
        attach_file '商品画像', [
          Rails.root.join('spec/files/book.png')
        ]
        expect { click_on '出品する' }.not_to raise_error
        expect(page).to have_content '商品名を入力してください'
      end
    end
  end

  describe 'editing and destroying items' do
    let(:item) { FactoryBot.create(:item, user: alice) }
    let(:unpublished_item) { FactoryBot.create(:unpublished_item, user: alice) }

    context 'when user owns their own item' do
      before do
        allow(DiscordNotifier).to receive(:with)
        allow(DiscordNotifier).to receive(:item_listed)
        allow(DiscordNotifier).to receive(:item_unlisted)
      end

      it 'user can edit their own item' do
        sign_in alice
        visit item_path(item)
        click_on '商品を編集する'
        fill_in '商品名', with: '編集済み商品'
        click_on '変更する'
        expect(page).to have_content 'Item was successfully updated.'
        expect(page).to have_content '編集済み商品'
        expect(DiscordNotifier).not_to have_received(:with)
        expect(DiscordNotifier).not_to have_received(:item_listed)
      end

      it 'user can select and delete already existing item images' do
        item = FactoryBot.create(:item, user: alice)
        item.images.attach(io: File.open(Rails.root.join('spec/files/book.png')), filename: 'book.png')
        item.images.attach(io: File.open(Rails.root.join('spec/files/books.png')), filename: 'books.png')

        sign_in alice
        visit item_path(item)
        click_on '商品を編集する'
        expect do
          expect(page).to have_selector("img[src$='book.png']")
          expect(page).to have_selector("img[src$='books.png']")
          find("img[src$='book.png']").click
          click_on '変更する'
          expect(page).to have_content 'Item was successfully updated.'
        end.to change { item.images.count }.from(2).to(1)
        expect(page).to have_selector("img[src$='books.png']")
        click_on '商品を編集する'
        expect(page).not_to have_selector("img[src$='book.png']")
        expect(page).to have_selector("img[src$='books.png']")
      end

      it 'user can destroy their own item' do
        sign_in alice
        visit item_path(item)
        click_on '商品を削除する'
        expect(page).to have_content 'Item was successfully destroyed.'
        expect(page).not_to have_content item.name
        expect(DiscordNotifier).not_to have_received(:with)
        expect(DiscordNotifier).not_to have_received(:item_unlisted)
      end
    end

    context "when user tries to edit or destroy another user's item" do
      it "user can't edit and destroy another user's item" do
        sign_in bob
        visit item_path(item)
        expect(page).not_to have_content 'Edit this item'
        expect(page).not_to have_content 'Destroy this item'
      end
    end

    context 'when user edits items as unpublished' do
      it 'user can make a listed item unpublished' do
        allow(DiscordNotifier).to receive(:with)
        allow(DiscordNotifier).to receive(:item_listed)
        allow(DiscordNotifier).to receive(:item_unlisted)

        sign_in alice
        visit item_path(item)
        expect(page).not_to have_content 'この商品は非公開です'
        click_on '商品を編集する'
        click_on '非公開として保存'
        expect(page).to have_content 'Item was successfully updated.'
        expect(page).to have_content 'この商品は非公開です'
        expect(DiscordNotifier).not_to have_received(:with)
        expect(DiscordNotifier).not_to have_received(:item_listed)
        expect(DiscordNotifier).not_to have_received(:item_unlisted)
      end

      it 'user can make an unpublished item listed' do
        expect(DiscordNotifier).to receive_message_chain(:with, :item_listed, :notify_now) # rubocop:disable RSpec/MessageChain

        sign_in alice
        visit item_path(unpublished_item)
        expect(page).to have_content 'この商品は非公開です'
        click_on '商品を編集する'
        click_on '出品する'
        expect(page).to have_content 'Item was successfully updated.'
        expect(page).not_to have_content 'この商品は非公開です'
      end
    end

    context 'when user wants to change price of an item' do
      it "user can't change price of a listed item" do
        sign_in alice
        visit item_path(item)
        click_on '商品を編集する'
        expect(page).to have_content '※この商品は出品中です。一度出品した商品の価格は、出品中は変更できません。'
        expect(page).to have_field '価格', readonly: true
      end

      it 'user can change price of an unpublished item' do
        sign_in alice
        visit item_path(unpublished_item)
        click_on '商品を編集する'
        expect(page).to have_field '価格', readonly: false
        fill_in '価格', with: 2000
        click_on '出品する'
        expect(page).to have_content 'Item was successfully updated.'
        expect(page).to have_content '¥2,000'
      end
    end

    context 'when user wants to edit an unpublished item whose deadline has passed once and no one has been selected as a buyer' do
      it 'user can edit it and list it again' do
        expect(DiscordNotifier).to receive_message_chain(:with, :item_listed, :notify_now) # rubocop:disable RSpec/MessageChain

        target_item = FactoryBot.create(:deadline_passed_once_and_not_buyer_selected_item, user: alice)
        sign_in alice
        visit item_path(target_item)
        click_on '商品を編集する'
        fill_in '商品名', with: '再出品商品'
        fill_in '購入希望の締切日', with: Time.zone.tomorrow
        click_on '出品する'
        expect(page).to have_content 'Item was successfully updated.'
        expect(page).to have_content '再出品商品'
      end
    end
  end

  describe 'editing and destroying items which have purchase requests' do
    let(:item) { FactoryBot.create(:item, user: alice) }

    before do
      FactoryBot.create(:purchase_request, item:, user: bob)
    end

    context 'when user edits items as unpublished' do
      it 'purchase requests are destroyed and notifications are sent' do
        expect(DiscordNotifier).to receive_message_chain(:with, :item_unlisted, :notify_now) # rubocop:disable RSpec/MessageChain

        sign_in alice
        visit item_path(item)
        click_on '商品を編集する'
        expect do
          click_on '非公開として保存'
          expect(page).to have_content 'Item was successfully updated.'
          expect(page).to have_content 'この商品は非公開です'
        end.to change { item.purchase_requests.count }.from(1).to(0)
      end
    end

    context 'when user destroy items' do
      it 'purchase requests are also destroyed and notifications are sent' do
        expect(DiscordNotifier).to receive_message_chain(:with, :item_unlisted, :notify_now) # rubocop:disable RSpec/MessageChain

        sign_in alice
        visit item_path(item)
        expect do
          click_on '商品を削除する'
          expect(page).to have_content 'Item was successfully destroyed.'
          expect(page).not_to have_content item.name
        end.to change { item.purchase_requests.count }.from(1).to(0)
      end
    end
  end

  describe 'indexing items' do
    it 'user can see currently listed items' do
      item = FactoryBot.create(:item, user: alice)
      unpublished_item = FactoryBot.create(:unpublished_item, user: alice)
      buyer_selected_item = FactoryBot.create(:buyer_selected_item, user: alice, buyer: bob)

      sign_in alice
      visit items_path
      expect(page).to have_content '出品中の商品'
      expect(page).to have_content item.name
      expect(page).not_to have_content unpublished_item.name
      expect(page).not_to have_content buyer_selected_item.name
    end

    describe 'showing images attached with items' do
      it 'user can see images attached with items' do
        item_with_images = FactoryBot.create(:item, user: alice)
        item_without_images = FactoryBot.create(:item, user: alice)
        item_with_images.images.attach(io: File.open(Rails.root.join('spec/files/book.png')), filename: 'book.png')
        item_with_images.images.attach(io: File.open(Rails.root.join('spec/files/books.png')), filename: 'books.png')

        sign_in alice
        visit items_path
        within "#item_container_#{item_with_images.id}" do
          expect(page).to have_selector("img[src$='book.png']")
          expect(page).not_to have_selector("img[src$='books.png']")
        end
        within "#item_container_#{item_without_images.id}" do
          expect(page).to have_content '🏷️'
          expect(page).to have_content '画像なし'
        end
      end
    end
  end

  describe 'showing items' do
    context 'when user checks their own item' do
      it 'user can see a label about the status of an each item' do
        unpublished_item = FactoryBot.create(:unpublished_item, user: alice)
        buyer_selected_item = FactoryBot.create(:buyer_selected_item, user: alice, buyer: bob)
        sign_in alice
        visit item_path(unpublished_item)
        expect(page).to have_content 'この商品は非公開です'
        expect(page).to have_link '商品を編集する'
        expect(page).to have_button '商品を削除する'

        visit item_path(buyer_selected_item)
        expect(page).to have_content '購入者が確定しました'
        expect(page).not_to have_link '商品を編集する'
        expect(page).to have_button '商品を削除する'
      end
    end

    context 'when user checks their own item between its deadline and lottery' do
      it 'user can see a label about waiting for lottery' do
        closed_yesterday_item = FactoryBot.create(:closed_yesterday_and_waiting_for_the_lottery_item, user: alice)

        sign_in alice
        visit item_path(closed_yesterday_item)
        expect(page).to have_content '購入者の抽選待ちです'
        expect(page).not_to have_link 'Edit this item'
        expect(page).not_to have_button 'Destroy this item'
      end
    end

    context "when user checks another user's item" do
      it 'user can see a label about the status of an each item' do
        currently_requesting_item = FactoryBot.create(:item, user: bob)
        FactoryBot.create(:purchase_request, item: currently_requesting_item, user: alice)
        selected_as_buyer_item = FactoryBot.create(:buyer_selected_item, user: bob, buyer: alice)
        FactoryBot.create(:purchase_request, item: selected_as_buyer_item, user: alice)
        not_selected_as_buyer_item = FactoryBot.create(:buyer_selected_item, user: bob, buyer: carol)
        FactoryBot.create(:purchase_request, item: not_selected_as_buyer_item, user: alice)
        just_selection_finished_item = FactoryBot.create(:buyer_selected_item, user: bob, buyer: carol)

        sign_in alice
        visit item_path(currently_requesting_item)
        expect(page).to have_content '購入希望を出しています'
        visit item_path(selected_as_buyer_item)
        expect(page).to have_content 'あなたが購入者となりました'
        visit item_path(not_selected_as_buyer_item)
        expect(page).to have_content '落選しました'
        visit item_path(just_selection_finished_item)
        expect(page).to have_content '終了しました'
      end
    end

    context 'when no images is attached with an item' do
      it 'user can see a default image' do
        item = FactoryBot.create(:item, user: alice)
        sign_in alice
        visit item_path(item)
        expect(page).to have_content '画像なし'
      end
    end
  end
end

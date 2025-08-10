# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DiscordNotifier', type: :model do
  let(:alice) { FactoryBot.create(:user) }
  let(:bob) { FactoryBot.create(:user, name: 'bob') }
  let(:carol) { FactoryBot.create(:user, name: 'carol') }
  let(:item) { FactoryBot.create(:item, user: alice) }

  describe '#item_listed' do
    it 'sends a message about that a new item has been listed' do
      params = { item: }
      expected = {
        body: '新しい商品が出品されました！',
        embed_message: EmbedMessageFormatter.new(item).execute
      }

      expect { DiscordNotifier.with(params).item_listed.notify_now }
        .to have_sent_notification(**expected)
    end
  end

  describe '#buyer_selected' do
    let(:buyer_selected_item) { FactoryBot.create(:buyer_selected_item, user: alice, buyer: bob) }

    before do
      FactoryBot.create(:purchase_request, user: bob, item: buyer_selected_item)
      FactoryBot.create(:purchase_request, user: carol, item: buyer_selected_item)
    end

    it 'sends a message about that a buyer has been selected' do
      params = { item: buyer_selected_item }
      body = <<~TEXT.chomp
        <@#{alice.uid}> さんの「#{buyer_selected_item.name}」の購入者が <@#{bob.uid}> さんに決定しました。
        CC: <@#{carol.uid}> さん
      TEXT

      expected = { body:, embed_message: EmbedMessageFormatter.new(buyer_selected_item).execute }

      expect { DiscordNotifier.with(params).buyer_selected.notify_now }
        .to have_sent_notification(**expected)
    end
  end

  describe '#buyer_not_selected' do
    it 'sends a message about that a no one has been selected as a buyer' do
      params = { item: }
      expected = { body: "<@#{alice.uid}> さんの「#{item.name}」は購入希望者がつかずに出品が終了しました。" }

      expect { DiscordNotifier.with(params).buyer_not_selected.notify_now }
        .to have_sent_notification(**expected)
    end
  end

  describe '#item_unlisted' do
    before do
      FactoryBot.create(:purchase_request, user: bob, item:)
      FactoryBot.create(:purchase_request, user: carol, item:)
    end

    it 'sends a message about that an item has been withdrew' do
      params = { item:, requesting_users: item.requesting_users }
      body = <<~TEXT.chomp
        #{alice.name} さんの「#{item.name}」の出品が取り下げられました。
        TO: <@#{bob.uid}> さん, <@#{carol.uid}> さん
      TEXT

      expected = { body: }

      expect { DiscordNotifier.with(params).item_unlisted.notify_now }
        .to have_sent_notification(**expected)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmbedMessageFormatter, type: :model do
  describe '#execute' do
    let(:alice) { FactoryBot.create(:user) }

    context 'when the shipping cost is paid by the lister' do
      let(:item) do
        FactoryBot.create(:item, name: 'テスト商品', description: '出品者が送料を負担するテスト商品', price: 1000,
                                 deadline: Date.tomorrow, shipping_cost_covered: true, payment_method: 'PayPay', user: alice)
      end

      it 'returns an embedded message that says that the cost is paid by the lister' do
        expect(EmbedMessageFormatter.new(item).execute).to eq(
          {
            title: 'テスト商品',
            url: Rails.application.routes.url_helpers.item_url(item),
            description: '出品者が送料を負担するテスト商品',
            timestamp: item.created_at,
            thumbnail: { url: alice.avatar_url },
            author: { name: 'alice', icon_url: alice.avatar_url },
            item_field: {
              price: '¥1,000',
              deadline: I18n.l(item.deadline),
              shipping: '出品者',
              payment: 'PayPay'
            }
          }
        )
      end
    end

    context 'when the shipping cost is paid by the buyer' do
      let(:item) do
        FactoryBot.create(:item, name: 'テスト商品', description: '購入者が送料を負担するテスト商品', price: 1000,
                                 deadline: Date.tomorrow, shipping_cost_covered: false, payment_method: 'PayPay', user: alice)
      end

      it 'returns an embedded message that says that the cost is paid by the buyer' do
        expect(EmbedMessageFormatter.new(item).execute).to eq(
          {
            title: 'テスト商品',
            url: Rails.application.routes.url_helpers.item_url(item),
            description: '購入者が送料を負担するテスト商品',
            timestamp: item.created_at,
            thumbnail: { url: alice.avatar_url },
            author: { name: 'alice', icon_url: alice.avatar_url },
            item_field: {
              price: '¥1,000',
              deadline: I18n.l(item.deadline),
              shipping: '購入者',
              payment: 'PayPay'
            }
          }
        )
      end
    end
  end
end

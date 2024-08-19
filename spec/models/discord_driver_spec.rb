# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordDriver, type: :model do
  let(:alice) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item, user: alice) }

  before do
    stub_request(:post, ENV['DISCORD_WEBHOOK_URL'])
  end

  describe '#call' do
    context 'when a sender name is designated' do
      before do
        DiscordDriver.new.call(
          {
            body: '新しい商品が出品されました！',
            sender_name: 'ピヨルド',
            embed_message: EmbedMessageFormatter.new(item).execute
          }
        )
      end

      it 'sends a POST request to Discord to send a message using the designated name' do
        expect(WebMock).to have_requested(:post, ENV['DISCORD_WEBHOOK_URL'])
          .with(body: hash_including(:embeds,
                                     content: '新しい商品が出品されました！',
                                     username: 'ピヨルド'))
      end
    end

    context "when a sender name isn't designated" do
      before do
        DiscordDriver.new.call(
          {
            body: '新しい商品が出品されました！',
            embed_message: EmbedMessageFormatter.new(item).execute
          }
        )
      end

      it 'sends a POST request to Discord to send a message using a default name' do
        expect(WebMock).to have_requested(:post, ENV['DISCORD_WEBHOOK_URL'])
          .with(body: hash_including(:embeds,
                                     content: '新しい商品が出品されました！',
                                     username: DiscordDriver::DEFAULT_SENDER_NAME))
      end
    end

    context 'when no embed messages is given' do
      before do
        DiscordDriver.new.call({ body: '出品が取り下げられました。' })
      end

      it 'sends a POST request to Discord to send a message without embed messages' do
        expect(WebMock).to have_requested(:post, ENV['DISCORD_WEBHOOK_URL'])
          .with(body: hash_including(content: '出品が取り下げられました。',
                                     embeds: []))
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuyerSelector, type: :model do
  let(:item) { instance_double(Item) }

  before do
    allow(item).to receive(:select_buyer!)
  end

  describe '#execute' do
    before do
      allow(item).to receive(:buyer_selected?).and_return(true)
    end

    context 'when a buyer of an item will be selected' do
      it 'calls Item#select_buyer! then notifies buyer has been selected' do
        expect(DiscordNotifier).to receive_message_chain(:with, :buyer_selected, :notify_now) # rubocop:disable RSpec/MessageChain
        BuyerSelector.new(item).execute
        expect(item).to have_received(:select_buyer!)
      end
    end

    context 'when a buyer of an item will not be selected' do
      before do
        allow(item).to receive_messages(buyer_selected?: false, unpublished?: true)
      end

      it 'calls Item#select_buyer! then notifies that a buyer has not been selected' do
        expect(DiscordNotifier).to receive_message_chain(:with, :buyer_not_selected, :notify_now) # rubocop:disable RSpec/MessageChain
        BuyerSelector.new(item).execute
        expect(item).to have_received(:select_buyer!)
      end
    end
  end
end

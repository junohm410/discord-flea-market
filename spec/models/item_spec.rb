# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:alice) { FactoryBot.create(:user) }

  describe '.accessible_for' do
    it 'returns their own items or not unpublished items by other users' do
      bob = FactoryBot.create(:user, name: 'bob')
      carol = FactoryBot.create(:user, name: 'carol')

      alices_item = FactoryBot.create(:item, user: alice)
      bobs_listing_item = FactoryBot.create(:item, user: bob)
      bobs_buyer_selected_item = FactoryBot.create(:buyer_selected_item, user: bob, buyer: carol)
      FactoryBot.create(:purchase_request, item: bobs_buyer_selected_item, user: carol)
      FactoryBot.create(:unpublished_item, user: bob)

      expect(Item.accessible_for(alice)).to contain_exactly(alices_item, bobs_listing_item, bobs_buyer_selected_item)
    end
  end

  describe '.closed_yesterday' do
    it 'returns items whose deadline is yesterday' do
      closed_yesterday_item = FactoryBot.build(:item, user: alice, deadline: Time.current.yesterday)
      closed_yesterday_item.save!(validate: false)
      FactoryBot.create(:item, user: alice, deadline: Time.current.beginning_of_day)
      FactoryBot.create(:item, user: alice, deadline: Time.current.tomorrow)

      expect(Item.closed_yesterday).to contain_exactly closed_yesterday_item
    end
  end

  describe 'validate deadline_later_than_today' do
    it "validates that the deadline can't be earlier than today" do
      item = FactoryBot.build(:item, user: alice, deadline: Time.current.yesterday)
      item.valid?
      expect(item.errors[:deadline]).to include "can't be earlier than today"
    end

    it 'validates that the deadline can be later than today' do
      item = FactoryBot.build(:item, user: alice, deadline: Time.current.tomorrow)
      item.valid?
      expect(item.errors[:deadline]).to be_empty
    end
  end

  describe '#changed_to_listed_from_unpublished?' do
    context 'when an item status has changed from unpublished to listed' do
      it 'returns true' do
        item = FactoryBot.create(:unpublished_item, user: alice)
        item.status = 'listed'
        item.save
        expect(item.changed_to_listed_from_unpublished?).to be true
      end
    end

    context 'when an item status has changed from listed to unpublished' do
      it 'returns false' do
        item = FactoryBot.create(:item, user: alice)
        item.status = 'unpublished'
        item.save
        expect(item.changed_to_listed_from_unpublished?).to be false
      end
    end
  end
end

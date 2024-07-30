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

  describe '.editable' do
    it 'returns items that are not buyer_selected' do
      listing_item = FactoryBot.create(:item, user: alice)
      unpublished_item = FactoryBot.create(:unpublished_item, user: alice)
      done_lottery_once_and_not_buyer_selected_item = FactoryBot.create(:deadline_passed_once_and_not_buyer_selected_item, user: alice)
      FactoryBot.create(:closed_yesterday_and_waiting_for_the_lottery_item, user: alice)
      FactoryBot.create(:buyer_selected_item, user: alice)

      expect(Item.editable).to contain_exactly(listing_item, unpublished_item, done_lottery_once_and_not_buyer_selected_item)
    end
  end

  describe '.closed_yesterday' do
    it 'only returns listed items whose deadline is yesterday' do
      closed_yesterday_item = FactoryBot.create(:closed_yesterday_and_waiting_for_the_lottery_item, user: alice)
      FactoryBot.create(:item, user: alice, deadline: Time.current.beginning_of_day)
      FactoryBot.create(:item, user: alice, deadline: Time.current.tomorrow)
      FactoryBot.create(:buyer_selected_item, user: alice)
      FactoryBot.create(:unpublished_item, user: alice)

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

    it 'validates that the deadline can be beginning of today' do
      item = FactoryBot.build(:item, user: alice, deadline: Time.current.beginning_of_day)
      item.valid?
      expect(item.errors[:deadline]).to be_empty
    end
  end

  describe 'validate price_cannot_be_changed_when_listed' do
    let(:listed_item) { FactoryBot.create(:item, user: alice) }
    let(:unpublished_item) { FactoryBot.create(:unpublished_item, user: alice) }

    context 'when the item is listed' do
      it 'validates that the price cannot be changed' do
        listed_item.update(price: 2000)
        expect(listed_item.errors[:price]).to include 'cannot be changed while the item is listed'
      end

      it 'validates that other columns except price can be changed' do
        listed_item.update(name: '更新後の商品名')
        expect(listed_item.errors[:price]).to be_empty
      end
    end

    context 'when the item is unpublished' do
      it 'validates that the price can be changed' do
        unpublished_item.update(price: 2000)
        expect(unpublished_item.errors[:price]).to be_empty
      end
    end

    context 'when the item is changed from unpublished to listed' do
      it 'validates that the price can be changed' do
        unpublished_item.price = 2000
        unpublished_item.status = 'listed'
        unpublished_item.valid?
        expect(unpublished_item.errors[:price]).to be_empty
      end
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

    context 'when an item status has not changed' do
      it 'returns false' do
        listed_item = FactoryBot.create(:item, user: alice)
        listed_item.update(name: '更新後の商品名')
        expect(listed_item.changed_to_unpublished_from_listed?).to be false

        unpublished_item = FactoryBot.create(:unpublished_item, user: alice)
        unpublished_item.update(name: '更新後の商品名')
        expect(unpublished_item.changed_to_unpublished_from_listed?).to be false
      end
    end
  end

  describe 'changed_to_unpublished_from_listed?' do
    context 'when an item status has changed from listed to unpublished' do
      it 'returns true' do
        item = FactoryBot.create(:item, user: alice)
        item.status = 'unpublished'
        item.save
        expect(item.changed_to_unpublished_from_listed?).to be true
      end
    end

    context 'when an item status has changed from unpublished to listed' do
      it 'returns false' do
        item = FactoryBot.create(:unpublished_item, user: alice)
        item.status = 'listed'
        item.save
        expect(item.changed_to_unpublished_from_listed?).to be false
      end
    end

    context 'when an item status has not changed' do
      it 'returns false' do
        listed_item = FactoryBot.create(:item, user: alice)
        listed_item.update(name: '更新後の商品名')
        expect(listed_item.changed_to_unpublished_from_listed?).to be false

        unpublished_item = FactoryBot.create(:unpublished_item, user: alice)
        unpublished_item.update(name: '更新後の商品名')
        expect(unpublished_item.changed_to_unpublished_from_listed?).to be false
      end
    end
  end
end

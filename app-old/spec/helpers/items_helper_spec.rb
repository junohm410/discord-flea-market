# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsHelper, type: :helper do
  let(:user) { create(:user) }

  describe '#item_image_url' do
    let(:item) { create(:item, user:) }

    context 'when item has images attached' do
      before do
        item.images.attach(
          io: StringIO.new('dummy image data'),
          filename: 'test_image.jpg',
          content_type: 'image/jpeg'
        )
      end

      it 'returns the variant URL of the first image' do
        result = helper.item_image_url(item)
        expect(result).to be_a(ActiveStorage::VariantWithRecord)
        expect(result.blob).to eq(item.images.first.blob)
      end
    end

    context 'when item has no images' do
      it 'returns the no_image.png path' do
        expect(helper.item_image_url(item)).to eq('no_image.png')
      end
    end
  end

  describe '#deadline_status' do
    let(:item) { build(:item, user:) }

    context 'when deadline has expired' do
      before { item.deadline = 1.day.ago }

      it 'returns expired status' do
        result = helper.deadline_status(item)
        expect(result[:text]).to eq('締切終了')
        expect(result[:status]).to eq('expired')
      end
    end

    context 'when deadline is today' do
      before { item.deadline = Date.current }

      it 'returns today status' do
        result = helper.deadline_status(item)
        expect(result[:text]).to eq('本日締切')
        expect(result[:status]).to eq('today')
      end
    end

    context 'when deadline is within 3 days' do
      before { item.deadline = 2.days.from_now }

      it 'returns soon status with days remaining' do
        result = helper.deadline_status(item)
        expect(result[:text]).to include('締切:')
        expect(result[:suffix]).to eq('(あと2日)')
        expect(result[:status]).to eq('soon')
      end
    end

    context 'when deadline is more than 3 days away' do
      before { item.deadline = 5.days.from_now }

      it 'returns normal status' do
        result = helper.deadline_status(item)
        expect(result[:text]).to include('締切:')
        expect(result[:status]).to eq('normal')
        expect(result[:suffix]).to be_nil
      end
    end
  end

  describe '#shipping_badge_text' do
    let(:item) { build(:item, user:) }

    context 'when shipping cost is covered by seller' do
      before { item.shipping_cost_covered = true }

      it 'returns 送料込み' do
        expect(helper.shipping_badge_text(item)).to eq('送料込み')
      end
    end

    context 'when shipping cost is not covered' do
      before { item.shipping_cost_covered = false }

      it 'returns 着払い' do
        expect(helper.shipping_badge_text(item)).to eq('着払い')
      end
    end
  end

  describe '#purchase_requests_info' do
    let(:item) { create(:item, user:) }

    context 'when item has no purchase requests' do
      it 'returns info with zero count' do
        result = helper.purchase_requests_info(item)
        expect(result[:count]).to eq(0)
        expect(result[:text]).to eq('希望者 0名')
        expect(result[:has_requests]).to be false
      end
    end

    context 'when item has purchase requests' do
      before do
        create_list(:purchase_request, 3, item:)
      end

      it 'returns info with request count' do
        result = helper.purchase_requests_info(item)
        expect(result[:count]).to eq(3)
        expect(result[:text]).to eq('希望者 3名')
        expect(result[:has_requests]).to be true
      end
    end
  end

  describe '#deadline_class' do
    let(:item) { build(:item, user:) }

    context 'when deadline has expired' do
      before { item.deadline = 1.day.ago }

      it 'returns red background class' do
        expect(helper.deadline_class(item)).to eq('border-red-300 bg-red-50')
      end
    end

    context 'when deadline is today' do
      before { item.deadline = Time.zone.today }

      it 'returns orange background class' do
        expect(helper.deadline_class(item)).to eq('border-orange-300 bg-orange-50')
      end
    end

    context 'when deadline is within 3 days' do
      before { item.deadline = 2.days.from_now }

      it 'returns yellow background class' do
        expect(helper.deadline_class(item)).to eq('border-yellow-300 bg-yellow-50')
      end
    end

    context 'when deadline is more than 3 days away' do
      before { item.deadline = 5.days.from_now }

      it 'returns gray background class' do
        expect(helper.deadline_class(item)).to eq('border-gray-200 bg-gray-50')
      end
    end
  end

  describe '#current_users_purchase_request' do
    let(:item) { create(:item, user:) }
    let(:current_user) { create(:user) }

    context 'when user is the item owner' do
      it 'returns nil' do
        expect(helper.current_users_purchase_request(item, item.user)).to be_nil
      end
    end

    context 'when user has a purchase request' do
      let!(:purchase_request) { create(:purchase_request, item:, user: current_user) }

      it 'returns the purchase request' do
        expect(helper.current_users_purchase_request(item, current_user)).to eq(purchase_request)
      end
    end

    context 'when user has no purchase request' do
      it 'returns nil' do
        expect(helper.current_users_purchase_request(item, current_user)).to be_nil
      end
    end
  end

  describe '#days_left' do
    let(:item) { build(:item, user:) }

    context 'when deadline has passed' do
      before { item.deadline = 2.days.ago }

      it 'returns negative days' do
        expect(helper.days_left(item)).to eq(-2)
      end
    end

    context 'when deadline is today' do
      before { item.deadline = Date.current }

      it 'returns 0' do
        expect(helper.days_left(item)).to eq(0)
      end
    end

    context 'when deadline is in the future' do
      before { item.deadline = 3.days.from_now }

      it 'returns positive days' do
        expect(helper.days_left(item)).to eq(3)
      end
    end
  end

  describe '#formatted_deadline' do
    let(:item) { build(:item, user:, deadline: Date.new(2025, 8, 15)) }

    it 'returns formatted date string' do
      expect(helper.formatted_deadline(item)).to eq('8月15日（Fri）')
    end
  end

  describe '#deadline_message' do
    let(:item) { build(:item, user:) }

    context 'when deadline has passed' do
      before { item.deadline = 2.days.ago }

      it 'returns expired message' do
        result = helper.deadline_message(item)
        expect(result[:text]).to eq('締切を過ぎています')
        expect(result[:class]).to eq('text-red-600')
      end
    end

    context 'when deadline is today' do
      before { item.deadline = Date.current }

      it 'returns today message' do
        result = helper.deadline_message(item)
        expect(result[:text]).to eq('本日締切')
        expect(result[:class]).to eq('text-orange-600')
      end
    end

    context 'when deadline is within 2 days' do
      before { item.deadline = 2.days.from_now }

      it 'returns days left message with orange color' do
        result = helper.deadline_message(item)
        expect(result[:text]).to eq('あと2日')
        expect(result[:class]).to eq('text-orange-600')
      end
    end

    context 'when deadline is more than 2 days away' do
      before { item.deadline = 5.days.from_now }

      it 'returns days left message with gray color' do
        result = helper.deadline_message(item)
        expect(result[:text]).to eq('あと5日')
        expect(result[:class]).to eq('text-gray-600')
      end
    end
  end

  describe '#shipping_cost_badge' do
    let(:item) { build(:item, user:) }

    context 'when shipping cost is covered' do
      before { item.shipping_cost_covered = true }

      it 'returns 送料込み' do
        expect(helper.shipping_cost_badge(item)).to eq('送料込み')
      end
    end

    context 'when shipping cost is not covered' do
      before { item.shipping_cost_covered = false }

      it 'returns 着払い' do
        expect(helper.shipping_cost_badge(item)).to eq('着払い')
      end
    end
  end

  describe '#purchase_request_count_text' do
    let(:item) { create(:item, user:) }

    before { create_list(:purchase_request, 5, item:) }

    it 'returns count with 名' do
      expect(helper.purchase_request_count_text(item)).to eq('5名')
    end
  end

  describe '#item_description_display' do
    let(:item) { build(:item, user:) }

    context 'when description is present' do
      before { item.description = 'これは商品の説明です' }

      it 'returns the description' do
        expect(helper.item_description_display(item)).to eq('これは商品の説明です')
      end
    end

    context 'when description is blank' do
      before { item.description = '' }

      it 'returns default message' do
        expect(helper.item_description_display(item)).to eq('説明は登録されていません。')
      end
    end
  end

  describe '#shipping_cost_display' do
    let(:item) { build(:item, user:) }

    context 'when shipping cost is covered' do
      before { item.shipping_cost_covered = true }

      it 'returns detailed shipping message' do
        expect(helper.shipping_cost_display(item)).to eq('出品者負担（送料込み）')
      end
    end

    context 'when shipping cost is not covered' do
      before { item.shipping_cost_covered = false }

      it 'returns detailed shipping message' do
        expect(helper.shipping_cost_display(item)).to eq('購入者負担（着払い）')
      end
    end
  end

  describe '#can_edit_item?' do
    let(:item) { build(:item, user:) }

    context 'when item is listed and deadline has not passed' do
      before do
        item.status = 'listed'
        item.deadline = 1.day.from_now
      end

      it 'returns true' do
        expect(helper.can_edit_item?(item)).to be true
      end
    end

    context 'when item is listed but deadline has passed' do
      before do
        item.status = 'listed'
        item.deadline = 1.day.ago
      end

      it 'returns false' do
        expect(helper.can_edit_item?(item)).to be false
      end
    end

    context 'when item is unpublished' do
      before { item.status = 'unpublished' }

      it 'returns true' do
        expect(helper.can_edit_item?(item)).to be true
      end
    end
  end

  describe '#can_delete_item_as_owner?' do
    let(:item) { build(:item, user:) }

    context 'when buyer is selected' do
      before { item.status = 'buyer_selected' }

      it 'returns true' do
        expect(helper.can_delete_item_as_owner?(item)).to be true
      end
    end

    context 'when buyer is not selected' do
      before { item.status = 'listed' }

      it 'returns false' do
        expect(helper.can_delete_item_as_owner?(item)).to be false
      end
    end
  end

  describe '#can_cancel_purchase_request?' do
    let(:item) { build(:item, user:, deadline: 1.day.from_now) }
    let(:purchase_request) { build(:purchase_request) }

    context 'when purchase request exists and deadline has not passed' do
      it 'returns true' do
        expect(helper.can_cancel_purchase_request?(item, purchase_request)).to be true
      end
    end

    context 'when purchase request is nil' do
      it 'returns false' do
        expect(helper.can_cancel_purchase_request?(item, nil)).to be false
      end
    end

    context 'when deadline has passed' do
      before { item.deadline = 1.day.ago }

      it 'returns false' do
        expect(helper.can_cancel_purchase_request?(item, purchase_request)).to be false
      end
    end
  end

  describe '#can_make_purchase_request?' do
    let(:item) { build(:item, user:) }

    context 'when deadline has not passed' do
      before { item.deadline = 1.day.from_now }

      it 'returns true' do
        expect(helper.can_make_purchase_request?(item)).to be true
      end
    end

    context 'when deadline has passed' do
      before { item.deadline = 1.day.ago }

      it 'returns false' do
        expect(helper.can_make_purchase_request?(item)).to be false
      end
    end
  end
end

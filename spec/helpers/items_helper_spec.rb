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
end

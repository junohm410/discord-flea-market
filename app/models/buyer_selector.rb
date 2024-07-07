# frozen_string_literal: true

class BuyerSelector
  def initialize(item)
    @item = item
    @purchase_requests = @item.purchase_requests
  end

  def select_buyer!
    if @purchase_requests.exists?
      buyer = @purchase_requests.sample.user
      @item.assign_attributes(buyer:, status: :buyer_selected)
    else
      @item.status = :unpublished
    end
    @item.save!(context: :select_buyer)
  end
end

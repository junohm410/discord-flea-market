# frozen_string_literal: true

class BuyerSelector
  def initialize(item)
    @item = item
  end

  def execute
    @item.select_buyer!
    notify_to_users
  end

  private

  def notify_to_users
    if @item.buyer_selected?
      DiscordNotifier.with(item: @item).buyer_selected.notify_now
    elsif @item.unpublished?
      DiscordNotifier.with(item: @item).buyer_not_selected.notify_now
    end
  end
end

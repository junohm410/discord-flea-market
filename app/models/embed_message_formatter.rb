# frozen_string_literal: true

class EmbedMessageFormatter
  def initialize(item)
    @item = item
    @user = item.user
  end

  def execute
    {
      title: @item.name,
      url: Rails.application.routes.url_helpers.item_url(@item),
      description: @item.description,
      timestamp: @item.created_at,
      thumbnail: { url: @user.avatar_url },
      author: { name: @user.name,
                icon_url: @user.avatar_url },
      item_field:
    }
  end

  private

  def item_field
    {
      price: ActiveSupport::NumberHelper.number_to_currency(@item.price),
      deadline: I18n.l(@item.deadline),
      shipping: @item.shipping_cost_covered ? '出品者' : '購入者',
      payment: @item.payment_method
    }
  end
end

# frozen_string_literal: true

class EmbedMessageFormatter
  def initialize(item)
    @item = item
    @user = item.user
  end

  def format_embed_message
    {
      title: @item.name,
      url: Rails.application.routes.url_helpers.item_url(@item),
      description: @item.description,
      timestamp: @item.created_at,
      thumbnail: { url: @user.avatar_url || 'https://cdn.discordapp.com/embed/avatars/0.png' },
      author: { name: @user.name,
                icon_url: @user.avatar_url || 'https://cdn.discordapp.com/embed/avatars/0.png' },
      item_field:
    }
  end

  private

  def item_field
    {
      price: @item.price,
      deadline: @item.deadline,
      shipping: @item.shipping_cost_covered ? '出品者' : '購入者',
      payment: @item.payment_method
    }
  end
end

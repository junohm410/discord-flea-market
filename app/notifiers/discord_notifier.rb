# frozen_string_literal: true

class DiscordNotifier < AbstractNotifier::Base
  self.driver = DiscordDriver.new

  def listed_item(params = {})
    params.merge!(@params)
    item = params[:item]

    embed_message = EmbedMessageFormatter.new(item).format_embed_message

    notification(
      body: '新しい商品が出品されました！',
      embed_message:
    )
  end

  def buyer_selected(params = {})
    params.merge!(@params)
    item = params[:item]
    buyer = item.buyer
    no_selected_users = item.purchase_requests.where.not(user: buyer).map(&:user)
    body = <<~TEXT.chomp
      <@#{item.user.uid}> さんの「#{item.name}」の購入者が <@#{buyer.uid}> さんに決定しました。
      CC: #{no_selected_users.map { |user| "<@#{user.uid}> さん" }.join(', ')}
    TEXT

    embed_message = EmbedMessageFormatter.new(item).format_embed_message

    notification(
      body:,
      embed_message:
    )
  end

  def buyer_not_selected(params = {})
    params.merge!(@params)
    item = params[:item]

    notification(
      body: "<@#{item.user.uid}> さんの「#{item.name}」は購入希望者がつかずに出品が終了しました。"
    )
  end
end

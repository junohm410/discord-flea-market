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
end

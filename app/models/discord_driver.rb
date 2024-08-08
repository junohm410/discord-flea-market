# frozen_string_literal: true

class DiscordDriver
  def call(params)
    client = Discordrb::Webhooks::Client.new(url: ENV['DISCORD_WEBHOOK_URL'])

    client.execute do |builder|
      embed_message = params[:embed_message]

      builder.content = params[:body]
      builder.username = params[:sender_name] || 'FBCフリマ'
      add_embed(builder, embed_message) if embed_message.present?
    end
  end

  private

  def add_embed(builder, embed_message)
    item_field = embed_message[:item_field]
    builder.add_embed do |embed|
      embed.title = embed_message[:title]
      embed.url = embed_message[:url]
      embed.description = embed_message[:description]
      embed.timestamp = embed_message[:timestamp]

      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(**embed_message[:thumbnail])
      embed.author = Discordrb::Webhooks::EmbedAuthor.new(**embed_message[:author])

      embed.add_field(name: Item.human_attribute_name(:price), value: item_field[:price])
      embed.add_field(name: Item.human_attribute_name(:deadline), value: item_field[:deadline])
      embed.add_field(name: Item.human_attribute_name(:shipping_cost_covered), value: item_field[:shipping], inline: true)
      embed.add_field(name: Item.human_attribute_name(:payment_method), value: item_field[:payment], inline: true)
    end
  end
end

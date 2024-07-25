# frozen_string_literal: true

class DiscordDriver
  def call(params)
    client = Discordrb::Webhooks::Client.new(url: ENV['DISCORD_WEBHOOK_URL'])

    client.execute do |builder|
      embed_message = params[:embed_message]
      item_field = params[:embed_message][:item_field]

      builder.content = params[:body]
      builder.username = 'FBCフリマ'
      builder.add_embed do |embed|
        embed.title = embed_message[:title]
        embed.url = embed_message[:url]
        embed.description = embed_message[:description]
        embed.timestamp = embed_message[:timestamp]

        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(**embed_message[:thumbnail])
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(**embed_message[:author])

        embed.add_field(name: '価格', value: item_field[:price])
        embed.add_field(name: '購入希望の締切日', value: item_field[:deadline])
        embed.add_field(name: '配送料の負担', value: item_field[:shipping], inline: true)
        embed.add_field(name: '希望する支払い方法', value: item_field[:payment], inline: true)
      end
    end
  end
end

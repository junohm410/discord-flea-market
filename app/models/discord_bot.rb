# frozen_string_literal: true

class DiscordBot
  def initialize
    @bot = Discordrb::Bot.new(token: ENV['DISCORD_BOT_TOKEN'])
  end

  def start
    monitoring_users_setting
    @bot.run
  end

  private

  def monitoring_users_setting
    @bot.member_leave do |event|
      User.remove_by_member_leaving_event(event)
    end

    @bot.member_update do |event|
      uid = event.user.id
      updated_member = JSON.parse(Discordrb::API::User.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", uid))

      name = updated_member['username']
      avatar_url = avatar_url(uid, updated_member['avatar'])

      user = User.find_by(uid:)
      if user
        user.update!(name:) if user.name != name
        user.update!(avatar_url:) if user.avatar_url != avatar_url
      end
    end
  end

  def avatar_url(uid, avatar_id)
    if avatar_id
      Discordrb::API::User.avatar_url(uid, avatar_id)
    else
      Discordrb::API::User.default_avatar
    end
  end
end

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
  end
end

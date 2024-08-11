# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordBot, type: :model do
  describe '#start' do
    it 'sets up for user monitoring and runs a bot' do
      bot_instance = instance_double(Discordrb::Bot)
      allow(bot_instance).to receive(:run)
      allow(Discordrb::Bot).to receive(:new).and_return(bot_instance)

      discord_bot = DiscordBot.new
      allow(discord_bot).to receive(:monitoring_users_setting)

      discord_bot.start
      expect(discord_bot).to have_received(:monitoring_users_setting)
      expect(bot_instance).to have_received(:run)
    end
  end
end

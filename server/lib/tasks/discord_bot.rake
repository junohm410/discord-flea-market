# frozen_string_literal: true

namespace :discord_bot do
  desc 'Start discord bot'
  task start: :environment do
    DiscordBot.new.start
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'alice' }
    uid { '1234567' }
    provider { 'discord' }
    avatar_url { 'https://cdn.discordapp.com/embed/avatars/1.png' }
  end
end

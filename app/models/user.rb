# frozen_string_literal: true

class User < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :buyable_items, class_name: 'Item', foreign_key: :buyer_id, inverse_of: :buyer, dependent: :nullify
  has_many :purchase_requests, dependent: :destroy
  has_many :requested_items, through: :purchase_requests, source: :item
  has_many :comments, dependent: :destroy

  devise :omniauthable, omniauth_providers: [:discord]

  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :provider, presence: true, inclusion: { in: %w[discord] }

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]
    avatar = auth_hash[:extra][:raw_info][:avatar]

    # サーバーメンバーではない場合リクエストに失敗してログインできない
    Discordrb::API::Server.resolve_member("Bot #{ENV['DISCORD_BOT_TOKEN']}", ENV['DISCORD_SERVER_ID'], uid)

    User.find_or_create_by!(provider:, uid:) do |user|
      user.name = name
      user.avatar_url = avatar ? Discordrb::API::User.avatar_url(uid, avatar) : Discordrb::API::User.default_avatar
    end
  end

  def self.remove_by_member_leaving_event(event)
    uid = event.user.id
    user = find_by(uid:)
    user&.destroy
  end

  def self.update_by_member_updating_event(event)
    uid = event.user.id
    updated_member = JSON.parse(Discordrb::API::User.resolve("Bot #{ENV['DISCORD_BOT_TOKEN']}", uid))

    name = updated_member['username']
    avatar = updated_member['avatar']
    avatar_url = avatar ? Discordrb::API::User.avatar_url(uid, avatar) : Discordrb::API::User.default_avatar

    user = User.find_by(uid:)
    return unless user

    user.update!(name:) if user.name != name
    user.update!(avatar_url:) if user.avatar_url != avatar_url
  end
end

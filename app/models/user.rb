# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:discord]

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash['provider']
    uid = auth_hash['uid']
    name = auth_hash['info']['name']
    avatar_url = auth_hash['info']['image']

    User.find_or_create_by!(provider:, uid:) do |user|
      user.name = name
      user.avatar_url = avatar_url
    end
  end
end

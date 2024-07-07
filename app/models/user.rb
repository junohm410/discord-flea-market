# frozen_string_literal: true

class User < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :buyable_items, class_name: 'Item', foreign_key: :buyer_id, inverse_of: :buyer, dependent: :nullify
  has_many :purchase_requests, dependent: :destroy
  has_many :requested_items, through: :purchase_requests, source: :item

  devise :omniauthable, omniauth_providers: [:discord]

  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :provider, presence: true, inclusion: { in: %w[discord] }

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

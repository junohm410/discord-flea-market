# frozen_string_literal: true

class ItemResource < ApplicationResource
  attributes :id

  attribute :title, &:name

  attributes :description, :price, :status

  attribute :deadline do |item|
    item.deadline&.iso8601
  end

  attribute :imageUrls do |item|
    # 署名付きURLではなくパスのみを返すことで、テスト/開発でのホスト依存を回避
    item.images.map do |blob|
      Rails.application.routes.url_helpers.rails_blob_path(blob, only_path: true)
    end
  end

  attribute :seller do |item|
    user = item.user
    next nil unless user

    {
      name: user.name,
      avatarUrl: user.avatar_url
    }
  end
end

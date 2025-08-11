# frozen_string_literal: true

class CommentResource < ApplicationResource
  attributes :id, :content

  attribute :author do |comment|
    {
      name: comment.user.name,
      avatarUrl: comment.user.avatar_url
    }
  end
end

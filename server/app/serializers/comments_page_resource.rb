# frozen_string_literal: true

class CommentsPageResource < ApplicationResource
  many :data, resource: CommentResource do |obj|
    obj[:data]
  end

  attribute :meta do |obj|
    obj[:meta]
  end
end

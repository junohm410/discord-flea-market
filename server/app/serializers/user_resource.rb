# frozen_string_literal: true

class UserResource < ApplicationResource
  attributes :id

  attribute :name, &:name
  attribute :avatarUrl, &:avatar_url
end

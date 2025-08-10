# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :item, counter_cache: true
  belongs_to :user

  validates :content, presence: true
end

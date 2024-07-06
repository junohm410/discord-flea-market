# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :user
  has_many :purchase_requests, dependent: :destroy
  has_many :requesting_users, through: :purchase_requests, source: :user

  enum status: { listed: 0, unpublished: 1 }

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :shipping_cost_covered, inclusion: { in: [true, false] }
  validates :deadline, presence: true

  scope :listed, -> { where(status: :listed) }
  scope :accessible_for, ->(user) { where(user:).or(listed) }
end

# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :user
  belongs_to :buyer, class_name: 'User', optional: true, inverse_of: :buyable_items
  has_many :purchase_requests, dependent: :destroy
  has_many :requesting_users, through: :purchase_requests, source: :user

  enum status: { listed: 0, unpublished: 1, buyer_selected: 2 }

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :shipping_cost_covered, inclusion: { in: [true, false] }
  validates :deadline, presence: true
  validate :deadline_later_than_today, unless: -> { validation_context == :select_buyer }

  scope :accessible_for, ->(user) { where(user:).or(listed) }
  scope :by_status, lambda { |status|
    case status
    when 'listed'
      listed
    when 'unpublished'
      unpublished
    end
  }

  private

  def deadline_later_than_today
    return unless deadline < Time.current.beginning_of_day

    errors.add(:deadline, "can't be later than today")
  end
end

# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :user
  belongs_to :buyer, class_name: 'User', optional: true, inverse_of: :buyable_items
  has_many :purchase_requests, dependent: :destroy
  has_many :requesting_users, through: :purchase_requests, source: :user
  has_many :comments, dependent: :destroy
  has_many_attached :images do |attachable|
    attachable.variant :optimized, resize_to_limit: [800, 800]
  end

  enum status: { listed: 0, unpublished: 1, buyer_selected: 2 }

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :shipping_cost_covered, inclusion: { in: [true, false] }
  validates :deadline, presence: true
  validates :images,
            content_type: %i[png jpg jpeg heic heif],
            limit: { max: 5, message: 'の枚数は5枚以下にしてください' },
            size: { less_than: 6.megabytes },
            processable_image: true
  validate :deadline_later_than_today
  validate :price_cannot_be_changed_when_listed, on: :update

  scope :accessible_for, ->(user) { where(user:).or(not_unpublished) }
  scope :editable, -> { listed.where('deadline >= ?', Time.zone.today).or(unpublished) }
  scope :closed_yesterday, -> { listed.where('deadline < ?', Time.zone.today) }

  paginates_per 10

  def select_buyer!
    if purchase_requests.exists?
      assign_attributes(buyer: purchase_requests.sample.user, status: :buyer_selected)
    else
      self.status = :unpublished
    end
    save!(validate: false)
  end

  def changed_to_listed_from_unpublished?
    saved_change_to_status == %w[unpublished listed]
  end

  def changed_to_unpublished_from_listed?
    saved_change_to_status == %w[listed unpublished]
  end

  private

  def deadline_later_than_today
    return if deadline.present? && deadline >= Time.zone.today

    errors.add(:deadline, "can't be earlier than today")
  end

  def price_cannot_be_changed_when_listed
    return if price_not_changed_during_listed? || change_to_be_saved_to_listed_from_unpublished?

    errors.add(:price, 'cannot be changed while the item is listed')
  end

  def change_to_be_saved_to_listed_from_unpublished?
    status_change_to_be_saved == %w[unpublished listed]
  end

  def price_not_changed_during_listed?
    !(listed? && will_save_change_to_price?)
  end
end

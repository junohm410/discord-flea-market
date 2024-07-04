# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :shipping_cost_covered, inclusion: { in: [true, false] }
  validates :deadline, presence: true
end

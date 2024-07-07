# frozen_string_literal: true

namespace :items do
  desc 'Select winners for items whose deadline has passed and no winner has been chosen yet'
  task select_buyers: :environment do
    items = Item.closed_yesterday

    items.find_each do |item|
      buyer_selector = BuyerSelector.new(item)
      buyer_selector.select_buyer!
    end
  end
end

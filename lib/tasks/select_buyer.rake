# frozen_string_literal: true

namespace :items do
  desc 'Select winners for items whose deadline has passed and no winner has been chosen yet'
  task select_buyers: :environment do
    items = Item.closed_yesterday

    items.find_each do |item|
      buyer_selector = BuyerSelector.new(item)
      buyer_selector.select_buyer!

      item.reload
      DiscordNotifier.with(item:).buyer_selected.notify_now if item.buyer_selected?
      DiscordNotifier.with(item:).buyer_not_selected.notify_now if item.unpublished?
    end
  end
end

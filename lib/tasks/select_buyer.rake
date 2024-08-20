# frozen_string_literal: true

namespace :items do
  desc 'Select winners for items whose deadline has passed and no buyer has been selected yet'
  task select_buyers: :environment do
    Item.closed_yesterday.find_each { |item| BuyerSelector.new(item).execute }
  end
end

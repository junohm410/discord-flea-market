# frozen_string_literal: true

namespace :items do
  desc 'Select buyers for items whose deadline has passed and buyer has not been selected yet'
  task select_buyers: :environment do
    Item.closed_yesterday.find_each { |item| BuyerSelector.new(item).execute }
  end
end

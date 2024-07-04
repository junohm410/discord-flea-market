# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { 'MyString' }
    description { 'MyText' }
    price { 1 }
    shipping_cost_covered { false }
    payment_method { 'MyString' }
    deadline { '2024-07-04 20:01:26' }
    user { nil }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :purchase_request do
    user { nil }
    item { nil }
  end
end

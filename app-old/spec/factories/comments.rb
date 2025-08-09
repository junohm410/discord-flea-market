# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'テストコメントです' }
    item { nil }
    user { nil }
  end
end

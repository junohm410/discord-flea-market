# frozen_string_literal: true

UID_DIGITS = 19

4.times do |n|
  User.create!(
    uid: format("%0#{UID_DIGITS}d", SecureRandom.random_number(10**UID_DIGITS)),
    name: "user#{n + 1}",
    provider: 'discord',
    avatar_url: nil
  )
end

user1 = User.first
user2 = User.second
user3 = User.third
user4 = User.fourth

10.times do |n|
  user1.items.create!(
    name: "締切が一ヶ月後の商品#{n + 1}",
    description: "締切が一ヶ月後の商品#{n + 1}の説明",
    price: 1000,
    shipping_cost_covered: true,
    payment_method: '楽天ペイ',
    deadline: Time.zone.today.next_month,
    status: :listed
  )
end

2.times do |n|
  item = user1.items.new(
    name: "締切が昨日の商品#{n + 1}",
    description: "締切が昨日の商品#{n + 1}の説明",
    price: 1000,
    shipping_cost_covered: true,
    payment_method: 'PayPay',
    deadline: Time.zone.yesterday,
    status: :listed
  )
  item.save!(validate: false)
end

11.times do |n|
  item = user2.items.new(
    name: "一ヶ月前に購入者確定済みの商品#{n + 1}",
    description: "一ヶ月前に購入者確定済みの商品#{n + 1}の説明",
    price: 1000,
    shipping_cost_covered: true,
    payment_method: '楽天ペイ',
    deadline: Time.zone.today.prev_month,
    status: :buyer_selected,
    buyer: user1
  )
  item.save!(validate: false)

  item.purchase_requests.create!(user: user1)
  item.purchase_requests.create!(user: user4)
end

listed_item = Item.listed.first
yesterdays_deadline_item = Item.closed_yesterday.first

PurchaseRequest.create!(item: listed_item, user: user2)
PurchaseRequest.create!(item: yesterdays_deadline_item, user: user2)
PurchaseRequest.create!(item: yesterdays_deadline_item, user: user3)

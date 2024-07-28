# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { 'テスト商品' }
    description { 'テスト商品です' }
    price { 1000 }
    shipping_cost_covered { true }
    payment_method { 'PayPay' }
    deadline { Time.current.tomorrow.beginning_of_day }
    user { nil }
    status { 0 }

    factory :unpublished_item do
      name { '非公開商品' }
      status { 1 }
    end

    # 購入確定済みの場合、deadlineは本来過去の日付になるべきだが、create時にバリデーションで弾かれるため、未来の日付のままにしている
    # 厳密なデータを作成する場合は、使用するテスト側で過去の日付を設定してbuildし、バリデーションを無効にしてsaveする
    factory :buyer_selected_item do
      name { '購入者確定済みの商品' }
      status { 2 }
    end

    factory :closed_yesterday_and_not_buyer_selected_item do
      name { '昨日締め切りかつ抽選前の商品' }
      deadline { Time.current.yesterday.beginning_of_day }

      to_create { |instance| instance.save(validate: false) }
    end
  end
end

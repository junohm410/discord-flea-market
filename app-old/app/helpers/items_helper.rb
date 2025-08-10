# frozen_string_literal: true

module ItemsHelper
  def item_image_url(item)
    if item.images.attached?
      item.images.first.variant(:optimized)
    else
      'no_image.png'
    end
  end

  def deadline_status(item)
    days = (item.deadline.to_date - Date.current).to_i

    if days.negative?
      { text: '締切終了', status: 'expired' }
    elsif days.zero?
      { text: '本日締切', status: 'today' }
    elsif days <= 3
      { text: "締切: #{l item.deadline, format: '%m/%d'}",
        suffix: "(あと#{days}日)",
        status: 'soon' }
    else
      { text: "締切: #{l item.deadline, format: '%m/%d'}", status: 'normal' }
    end
  end

  def shipping_badge_text(item)
    item.shipping_cost_covered ? '送料込み' : '着払い'
  end

  def purchase_requests_info(item)
    count = item.purchase_requests.size
    { count:, text: "希望者 #{count}名", has_requests: count.positive? }
  end

  def deadline_class(item)
    if item.deadline < Time.zone.today
      'border-red-300 bg-red-50'
    elsif item.deadline == Time.zone.today
      'border-orange-300 bg-orange-50'
    elsif (item.deadline - Time.zone.today).to_i <= 3
      'border-yellow-300 bg-yellow-50'
    else
      'border-gray-200 bg-gray-50'
    end
  end

  def current_users_purchase_request(item, current_user)
    return nil if item.user == current_user

    item.purchase_requests.find_by(user_id: current_user.id)
  end

  def days_left(item)
    (item.deadline.to_date - Date.current).to_i
  end

  def formatted_deadline(item)
    item.deadline.strftime('%-m月%-d日（%a）')
  end

  def deadline_message(item)
    days = days_left(item)

    if days.negative?
      { text: '締切を過ぎています', class: 'text-red-600' }
    elsif days.zero?
      { text: '本日締切', class: 'text-orange-600' }
    else
      { text: "あと#{days}日", class: days <= 2 ? 'text-orange-600' : 'text-gray-600' }
    end
  end

  def shipping_cost_badge(item)
    item.shipping_cost_covered ? '送料込み' : '着払い'
  end

  def purchase_request_count_text(item)
    "#{item.purchase_requests.size}名"
  end

  def item_description_display(item)
    item.description.presence || '説明は登録されていません。'
  end

  def shipping_cost_display(item)
    item.shipping_cost_covered ? '出品者負担（送料込み）' : '購入者負担（着払い）'
  end

  def can_edit_item?(item)
    (item.listed? && item.deadline >= Time.zone.today) || item.unpublished?
  end

  def can_delete_item_as_owner?(item)
    item.buyer_selected?
  end

  def can_cancel_purchase_request?(item, purchase_request)
    purchase_request.present? && item.deadline >= Time.zone.today
  end

  def can_make_purchase_request?(item)
    item.deadline >= Time.zone.today
  end
end

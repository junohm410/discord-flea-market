# frozen_string_literal: true

module ItemsHelper
  def item_image_url(item)
    if item.images.attached?
      item.images.first.variant(:medium)
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
end

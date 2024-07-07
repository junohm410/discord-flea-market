# frozen_string_literal: true

class RequestedItemsController < ApplicationController
  def index
    items = current_user.requested_items
    @items =
      case params[:status]
      when 'requested'
        items.listed
      when 'selected_as_buyer'
        items.where(buyer: current_user)
      when 'not_selected'
        items.buyer_selected.where.not(buyer: current_user)
      else
        items
      end
  end
end

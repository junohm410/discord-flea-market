# frozen_string_literal: true

class RequestedItemsController < ApplicationController
  def index
    items = current_user.requested_items
    @items =
      case params[:status]
      when 'requested'
        items.listed.includes(:user).includes(:images_attachments)
      when 'selected_as_buyer'
        items.where(buyer: current_user).includes(:user, :buyer, :images_attachments)
      when 'not_selected'
        items.buyer_selected.where.not(buyer: current_user).includes(:user, :buyer, :images_attachments)
      else
        items.includes(:user, :buyer, :images_attachments)
      end
  end
end

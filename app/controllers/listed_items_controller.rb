# frozen_string_literal: true

class ListedItemsController < ApplicationController
  def index
    items = current_user.items
    @items =
      case params[:status]
      when 'listed'
        items.listed.includes(:images_attachments)
      when 'unpublished'
        items.unpublished.includes(:images_attachments)
      when 'buyer_selected'
        items.buyer_selected.includes(:images_attachments)
      else
        items.includes(:images_attachments)
      end
  end
end

# frozen_string_literal: true

class ListedItemsController < ApplicationController
  def index
    items = current_user.items
    @items =
      case params[:status]
      when 'listed'
        items.listed.includes(:user, :images_attachments)
      when 'unpublished'
        items.unpublished.includes(:user, :images_attachments)
      when 'buyer_selected'
        items.buyer_selected.includes(:user, :images_attachments)
      else
        items.includes(:user, :images_attachments)
      end.order(id: :desc).page(params[:page])
  end
end

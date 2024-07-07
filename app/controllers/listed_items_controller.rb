# frozen_string_literal: true

class ListedItemsController < ApplicationController
  def index
    items = current_user.items
    @items =
      case params[:status]
      when 'listed'
        items.listed
      when 'unpublished'
        items.unpublished
      when 'buyer_selected'
        items.buyer_selected
      else
        items
      end
  end
end

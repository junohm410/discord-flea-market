# frozen_string_literal: true

class RequestedItemsController < ApplicationController
  def index
    # TODO: 当選機能を実装したら、statusによって表示するアイテムを絞り込むようにする
    @items = current_user.requested_items
  end
end

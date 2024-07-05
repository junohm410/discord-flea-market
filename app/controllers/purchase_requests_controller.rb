# frozen_string_literal: true

class PurchaseRequestsController < ApplicationController
  def create
    item = Item.find(params[:item_id])
    current_user.purchase_requests.create!(item:)
    redirect_to item, notice: '購入希望を出しました'
  end

  def destroy
    purchase_request = current_user.purchase_requests.find(params[:id])
    purchase_request.destroy!
    redirect_to purchase_request.item, notice: '購入希望を取り消しました', status: :see_other
  end
end

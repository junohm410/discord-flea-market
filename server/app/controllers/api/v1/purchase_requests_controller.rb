# frozen_string_literal: true

module Api
  module V1
    class PurchaseRequestsController < Api::BaseController
      before_action :authenticate_user!

      def create
        item = Item.find(params[:item_id])
        current_user.purchase_requests.create!(item:)
        render body: ItemResource.new(item).serialize, content_type: 'application/json', status: :created
      end

      def destroy
        purchase_request = current_user.purchase_requests.find(params[:id])
        item = purchase_request.item
        purchase_request.destroy!
        render body: ItemResource.new(item).serialize, content_type: 'application/json'
      end
    end
  end
end

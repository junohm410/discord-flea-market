# frozen_string_literal: true

module Api
  module V1
    class ItemsController < Api::BaseController
      before_action :authenticate_user!, only: %i[create update destroy]
      before_action :set_owned_item, only: %i[update destroy]

      def index
        items = Item.listed.order(id: :desc).page(params[:page]).per(params[:per])
        page = {
          data: items,
          meta: {
            total: items.total_count,
            totalPages: items.total_pages,
            currentPage: items.current_page,
            per: items.limit_value,
            hasPrev: items.current_page > 1,
            hasNext: items.current_page < items.total_pages
          }
        }
        render body: ItemsPageResource.new(page).serialize, content_type: 'application/json'
      end

      def show
        item = Item.listed.find(params[:id])
        data_json = ItemResource.new(item).serialize
        render body: { data: JSON.parse(data_json) }.to_json, content_type: 'application/json'
      end

      def create
        item = current_user.items.new(item_params)
        if item.save
          render body: { data: JSON.parse(ItemResource.new(item).serialize) }.to_json,
                 content_type: 'application/json', status: :created
        else
          render json: { error: { code: 'unprocessable_entity', message: 'Validation failed', details: item.errors.full_messages } },
                 status: :unprocessable_entity
        end
      end

      def update
        if @item.update(item_params)
          render body: { data: JSON.parse(ItemResource.new(@item).serialize) }.to_json, content_type: 'application/json'
        else
          render json: { error: { code: 'unprocessable_entity', message: 'Validation failed', details: @item.errors.full_messages } },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @item.destroy!
        head :no_content
      end

      private

      def set_owned_item
        @item = current_user.items.find(params[:id])
      end

      def item_params
        params.require(:item).permit(:name, :description, :price, :shipping_cost_covered, :payment_method, :deadline, :status)
      end
    end
  end
end

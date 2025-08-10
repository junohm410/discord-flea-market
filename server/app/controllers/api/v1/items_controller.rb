# frozen_string_literal: true

module Api
  module V1
    class ItemsController < Api::BaseController
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
    end
  end
end

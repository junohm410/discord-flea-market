# frozen_string_literal: true

module Api
  module V1
    module Me
      class ListedItemsController < Api::BaseController
        before_action :authenticate_user!

        def index
          items = build_items
          render body: ItemsPageResource.new(build_page(items)).serialize, content_type: 'application/json'
        end

        private

        def build_items
          scope = current_user.items
          filtered =
            case params[:status]
            when 'listed' then scope.listed
            when 'unpublished' then scope.unpublished
            when 'buyer_selected' then scope.buyer_selected
            else scope
            end
          filtered.includes(:user, :images_attachments).order(id: :desc).page(params[:page]).per(params[:per])
        end

        def build_page(items)
          {
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
        end
      end
    end
  end
end

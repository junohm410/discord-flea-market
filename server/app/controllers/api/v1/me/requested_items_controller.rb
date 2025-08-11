# frozen_string_literal: true

module Api
  module V1
    module Me
      class RequestedItemsController < Api::BaseController
        before_action :authenticate_user!

        def index
          items = build_items
          render body: ItemsPageResource.new(build_page(items)).serialize, content_type: 'application/json'
        end

        private

        def build_items
          scope = current_user.requested_items
          filtered =
            case params[:status]
            when 'requested' then scope.listed
            when 'selected_as_buyer' then scope.where(buyer: current_user)
            when 'not_selected' then scope.buyer_selected.where.not(buyer: current_user)
            else scope
            end
          filtered.includes(:user, :buyer, :images_attachments).order(id: :desc).page(params[:page]).per(params[:per])
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

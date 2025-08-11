# frozen_string_literal: true

module Api
  module V1
    class CommentsController < Api::BaseController
      before_action :authenticate_user!
      before_action :set_comment, only: %i[update destroy]

      def index
        item = Item.find(params[:item_id])
        comments = item.comments.includes(:user).order(id: :desc).page(params[:page]).per(params[:per])
        page = {
          data: comments,
          meta: {
            total: comments.total_count,
            totalPages: comments.total_pages,
            currentPage: comments.current_page,
            per: comments.limit_value,
            hasPrev: comments.current_page > 1,
            hasNext: comments.current_page < comments.total_pages
          }
        }
        render body: CommentsPageResource.new(page).serialize, content_type: 'application/json'
      end

      def create
        item = Item.find(params[:item_id])
        comment = item.comments.build(comment_params.merge(user: current_user))

        if comment.save
          render body: CommentResource.new(comment).serialize, content_type: 'application/json', status: :created
        else
          render json: { error: { code: 'unprocessable_entity', message: 'Validation failed', details: comment.errors.full_messages } },
                 status: :unprocessable_entity
        end
      end

      def update
        if @comment.update(comment_params)
          render body: CommentResource.new(@comment).serialize, content_type: 'application/json'
        else
          render json: { error: { code: 'unprocessable_entity', message: 'Validation failed', details: @comment.errors.full_messages } },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @comment.destroy!
        head :no_content
      end

      private

      def set_comment
        @comment = current_user.comments.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end

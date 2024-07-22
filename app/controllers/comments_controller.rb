# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    item = Item.find(params[:item_id])
    comment = item.comments.build(comment_params)
    comment.user = current_user
    comment.save!
    redirect_to item, notice: 'コメントを投稿しました'
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    item = comment.item
    comment.destroy!
    redirect_to item, notice: 'コメントを削除しました', status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end

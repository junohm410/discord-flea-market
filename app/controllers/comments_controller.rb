# frozen_string_literal: true

class CommentsController < ApplicationController
  def edit
    @comment = current_user.comments.find(params[:id])
    render partial: 'items/comments_form', locals: { comment: @comment }, layout: false
  end

  def create
    item = Item.find(params[:item_id])
    comment = item.comments.build(comment_params)
    comment.user = current_user
    comment.save!
    redirect_to item, notice: 'コメントを投稿しました'
  end

  def update
    comment = current_user.comments.find(params[:id])

    if comment.update(comment_params)
      flash.now[:notice] = 'コメントを更新しました'
      render partial: 'items/comment_update', locals: { item: comment.item, comment: }
    else
      render partial: 'items/comments_form', locals: { comment: }, layout: false, status: :unprocessable_entity
    end
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

# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[edit update destroy]

  def new
    @comment = Item.find(params[:item_id]).comments.new
    @comment.user = current_user
  end

  def edit; end

  def create
    item = Item.find(params[:item_id])
    @comment = item.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      flash.now[:notice] = 'コメントを投稿しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      flash.now[:notice] = 'コメントを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy!
    flash.now[:notice] = 'コメントを削除しました'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end
end

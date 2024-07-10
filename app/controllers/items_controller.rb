# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_item, only: %i[edit update destroy]

  # GET /items
  def index
    @items = Item.listed.includes(:user)
  end

  # GET /items/1
  def show
    @item = Item.accessible_for(current_user).find(params[:id])
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit; end

  # POST /items
  def create
    @item = current_user.items.new(item_params)
    set_unpublished

    if @item.save
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    set_unpublished
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy!
    redirect_to items_url, notice: 'Item was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = current_user.items.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :description, :price, :shipping_cost_covered, :payment_method, :deadline)
  end

  def set_unpublished
    @item.status = params[:commit] == '非公開として保存' ? 'unpublished' : 'listed'
  end
end

# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_item, only: %i[update destroy]

  # GET /items
  def index
    @items = Item.listed.includes(:user, :images_attachments).order(id: :desc).page(params[:page])
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
  def edit
    @item = current_user.items.editable.find(params[:id])
  end

  # POST /items
  def create
    @item = current_user.items.new(item_params)
    set_unpublished

    if @item.save
      DiscordNotifier.with(item: @item).item_listed.notify_now if @item.listed?
      redirect_to @item, notice: 'Item was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    set_unpublished
    if @item.update(item_params)
      DiscordNotifier.with(item: @item).item_listed.notify_now if @item.changed_to_listed_from_unpublished?
      if @item.changed_to_unpublished_from_listed?
        requesting_users = @item.requesting_users.to_a
        if requesting_users.present?
          @item.purchase_requests.destroy_all
          DiscordNotifier.with(item: @item, requesting_users:).item_unlisted.notify_now
        end
      end
      redirect_to @item, notice: 'Item was successfully updated.', status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    requesting_users = @item.requesting_users.to_a
    @item.destroy!
    DiscordNotifier.with(item: @item, requesting_users:).item_unlisted.notify_now if requesting_users.present?
    redirect_to items_url, notice: 'Item was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = current_user.items.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:name, :description, :price, :shipping_cost_covered, :payment_method, :deadline, images: [])
  end

  def set_unpublished
    @item.status = params[:commit] == '非公開として保存' ? 'unpublished' : 'listed'
  end
end

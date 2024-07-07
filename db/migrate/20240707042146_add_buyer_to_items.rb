class AddBuyerToItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :items, :buyer, foreign_key: { to_table: :users }
  end
end

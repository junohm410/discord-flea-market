class CreatePurchaseRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :purchase_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end

    add_index :purchase_requests, %i[user_id item_id], unique: true
  end
end

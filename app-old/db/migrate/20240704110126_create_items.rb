class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :price, null: false
      t.boolean :shipping_cost_covered, null: false
      t.string :payment_method
      t.datetime :deadline, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

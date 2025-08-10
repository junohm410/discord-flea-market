class AddColumnToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :purchase_requests_count, :integer
  end
end

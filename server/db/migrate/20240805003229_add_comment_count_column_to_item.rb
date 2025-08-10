class AddCommentCountColumnToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :comments_count, :integer
  end
end

class AddCategoryToGood < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :category_id, :integer
    add_index :goods, :category_id
  end
end

class RemovePriceFromRating < ActiveRecord::Migration[5.0]
  def up
    remove_column :reviews, :price
    remove_column :aggregated_ratings, :price
  end

  def down
  end
end

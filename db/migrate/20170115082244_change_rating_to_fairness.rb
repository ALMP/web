class ChangeRatingToFairness < ActiveRecord::Migration[5.0]
  def change
    change_column :reviews, :rating, :decimal, default: 0
    add_column :reviews, :fairness, :integer, default: 0
    add_column :aggregated_ratings, :fairness, :decimal, default: 0
  end
end

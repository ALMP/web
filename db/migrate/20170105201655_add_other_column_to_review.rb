class AddOtherColumnToReview < ActiveRecord::Migration[5.0]
  def change
    add_column :aggregated_ratings, :other, :decimal, default: 0
  end
end

class AddRecommendatorToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :recommendator, :citext
  end
end

class AddStatusToReview < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :status, :string
    add_index :reviews, :status
  end
end

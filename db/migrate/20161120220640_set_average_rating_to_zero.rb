class SetAverageRatingToZero < ActiveRecord::Migration[5.0]
  def up
    change_column :companies, :average_rating, :numeric, default: 0
    Company.where(average_rating: nil).update_all average_rating: 0
  end

  def down
    change_column :companies, :average_rating, :numeric, default: nil
  end
end

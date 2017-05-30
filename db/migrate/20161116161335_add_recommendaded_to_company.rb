class AddRecommendadedToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :recommended, :decimal, default: 0
  end
end

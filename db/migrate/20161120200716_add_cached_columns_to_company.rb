class AddCachedColumnsToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :last_review_added, :datetime
  end
end

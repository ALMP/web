class AddCompaniesCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :companies_count, :integer, :null => false, :default => 0
  end
end

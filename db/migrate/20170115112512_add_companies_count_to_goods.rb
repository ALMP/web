class AddCompaniesCountToGoods < ActiveRecord::Migration
  def change
    add_column :goods, :companies_count, :integer, :null => false, :default => 0
  end
end

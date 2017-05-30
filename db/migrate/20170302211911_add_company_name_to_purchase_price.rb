class AddCompanyNameToPurchasePrice < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_prices, :company_name, :string
    change_column :purchase_prices, :quantity, :integer, default: 1
  end
end

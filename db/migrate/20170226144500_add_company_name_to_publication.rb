class AddCompanyNameToPublication < ActiveRecord::Migration[5.0]
  def change
    add_column :publications, :company_name, :string
  end
end

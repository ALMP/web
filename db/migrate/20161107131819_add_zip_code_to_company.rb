class AddZipCodeToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :zipcode, :string
  end
end

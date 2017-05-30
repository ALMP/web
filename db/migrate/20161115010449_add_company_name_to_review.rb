class AddCompanyNameToReview < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :company_name, :string
  end
end

class CreateCompanyAliases < ActiveRecord::Migration[5.0]
  def change
    create_table :company_aliases do |t|
      t.references :company, index: true
      t.string :name, null: false
      t.timestamps
    end
  end
end

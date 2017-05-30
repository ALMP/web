# frozen_string_literal: true
class AddJoinTablesToCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :categories_companies, id: false do |t|
      t.references :category, null: false
      t.references :company, null: false
    end
    add_index :categories_companies, %i(company_id category_id), unique: true

    create_table :companies_goods, id: false do |t|
      t.references :good, null: false
      t.references :company, null: false
    end
    add_index :companies_goods, %i(company_id good_id), unique: true
  end
end

# frozen_string_literal: true
class AddGoodsAndIndustryToCompanies < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :industry, :string
    add_column :companies, :goods_type, :string
  end
end

# frozen_string_literal: true
class AddCityToCompanyByAssociation < ActiveRecord::Migration[5.0]
  def change
    remove_column :companies, :city
    add_column :companies, :city_id, :integer, index: true
  end
end

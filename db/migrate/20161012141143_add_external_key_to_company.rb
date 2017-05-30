# frozen_string_literal: true
class AddExternalKeyToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :external_key, :string, unique: true
  end
end

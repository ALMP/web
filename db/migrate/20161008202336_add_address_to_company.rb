# frozen_string_literal: true
class AddAddressToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :address, :string
  end
end

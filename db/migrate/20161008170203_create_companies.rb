# frozen_string_literal: true
class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :url
      t.citext :email
      t.string :phone

      t.timestamps
    end
  end
end

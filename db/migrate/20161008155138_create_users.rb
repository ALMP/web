# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    enable_extension :citext

    create_table :users do |t|
      t.citext :email, null: false, unique: true

      t.timestamps
    end
  end
end

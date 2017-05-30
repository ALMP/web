# frozen_string_literal: true
class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
    end

    reversible do |dir|
      dir.up do
        City.create_translation_table! name: :citext
      end

      dir.down do
        City.drop_translation_table!
      end
    end
  end
end

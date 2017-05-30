# frozen_string_literal: true
class CreateGoods < ActiveRecord::Migration[5.0]
  def change
    create_table :goods do |t|
    end

    reversible do |dir|
      dir.up do
        Good.create_translation_table! name: :citext
      end

      dir.down do
        Good.drop_translation_table!
      end
    end
  end
end

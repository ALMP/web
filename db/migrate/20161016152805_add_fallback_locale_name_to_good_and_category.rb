# frozen_string_literal: true
class AddFallbackLocaleNameToGoodAndCategory < ActiveRecord::Migration[5.0]
  def change
    add_column :goods, :fallback_locale_name, :citext
    add_column :categories, :fallback_locale_name, :citext
  end
end

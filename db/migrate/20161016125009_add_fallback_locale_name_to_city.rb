# frozen_string_literal: true
class AddFallbackLocaleNameToCity < ActiveRecord::Migration[5.0]
  def change
    add_column :cities, :fallback_locale_name, :citext
  end
end

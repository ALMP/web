# frozen_string_literal: true
class AddSearchIndexForCompanyName < ActiveRecord::Migration[5.0]
  def change
    enable_extension :pg_trgm
    add_index :companies, 'name gin_trgm_ops', using: :gin, name: 'index_companies_on_name_gin_trgm_ops'
    add_index :companies, 'url gin_trgm_ops', using: :gin, name: 'index_companies_on_url_gin_trgm_ops'
    add_index :companies, 'email gin_trgm_ops', using: :gin, name: 'index_companies_on_email_gin_trgm_ops'
    add_index :companies, 'phone gin_trgm_ops', using: :gin, name: 'index_companies_on_phone_gin_trgm_ops'

    add_index :city_translations, 'name gin_trgm_ops', using: :gin, name: 'index_city_translations_on_name_gin_trgm_ops'
    add_index :category_translations, 'name gin_trgm_ops',
              using: :gin, name: 'index_category_translations_on_name_gin_trgm_ops'
    add_index :good_translations, 'name gin_trgm_ops', using: :gin, name: 'index_good_translations_on_name_gin_trgm_ops'
  end
end

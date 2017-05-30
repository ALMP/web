class AddFtsIndices < ActiveRecord::Migration[5.0]
  def change
    add_index :companies, "to_tsvector('english', name)", using: :gin, name: 'index_companies_fts_english_name'
    add_index :companies, "to_tsvector('english', description)", using: :gin, name: 'index_companies_fts_english_desc'
    add_index :companies, "to_tsvector('russian', name)", using: :gin, name: 'index_companies_fts_russian_name'
    add_index :companies, "to_tsvector('russian', description)", using: :gin, name: 'index_companies_fts_russian_desc'
    add_index :companies, "to_tsvector('simple', name)", using: :gin, name: 'index_companies_fts_simple_name'
    add_index :companies, "to_tsvector('simple', description)", using: :gin, name: 'index_companies_fts_simple_desc'
  end
end

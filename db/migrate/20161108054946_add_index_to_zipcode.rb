class AddIndexToZipcode < ActiveRecord::Migration[5.0]
  def change
    add_index :companies, 'zipcode gin_trgm_ops', using: :gin, name: 'index_companies_on_zipcode_gin_trgm_ops'
  end
end

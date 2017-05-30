class FixCompaniesIndices < ActiveRecord::Migration[5.0]
  def up
    remove_index :companies, name: :index_companies_fts_english_name
    remove_index  :companies, name: :index_companies_fts_english_desc
    remove_index  :companies, name: :index_companies_fts_russian_name
    remove_index  :companies,name: :index_companies_fts_russian_desc
    remove_index  :companies,name: :index_companies_fts_simple_name
    remove_index  :companies,name: :index_companies_fts_simple_desc

    execute <<-SQL
      CREATE INDEX index_companies_fts_russian ON companies USING gin((to_tsvector('russian'::regconfig, COALESCE((name)::text, ''::text)) || to_tsvector('russian'::regconfig, COALESCE(description, ''::text))));
      CREATE INDEX index_companies_fts_english ON companies USING gin((to_tsvector('english'::regconfig, COALESCE((name)::text, ''::text)) || to_tsvector('english'::regconfig, COALESCE(description, ''::text))));
      CREATE INDEX index_companies_fts_simple ON companies USING gin((to_tsvector('simple'::regconfig, COALESCE((name)::text, ''::text)) || to_tsvector('simple'::regconfig, COALESCE(description, ''::text))));
    SQL
  end

  def down
    remove_index  :companies, name: :index_companies_fts_russian
    remove_index  :companies, name: :index_companies_fts_english
    remove_index  :companies, name: :index_companies_fts_simple
  end
end

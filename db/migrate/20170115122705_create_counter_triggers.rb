class CreateCounterTriggers < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE FUNCTION increment_counter(table_name text, column_name text, id integer, step integer)  
      RETURNS VOID AS $$
        DECLARE
          table_name text := quote_ident(table_name);
          column_name text := quote_ident(column_name);
          conditions text := ' WHERE id = $1';
          updates text := column_name || '=' || column_name || '+' || step;
        BEGIN
          EXECUTE 'UPDATE ' || table_name || ' SET ' || updates || conditions
          USING id;
        END;
      $$ LANGUAGE plpgsql;
    SQL

    execute <<-SQL
      CREATE FUNCTION counter_cache()  
      RETURNS trigger AS $$
        DECLARE
          table_name text := quote_ident(TG_ARGV[0]);
          counter_name text := quote_ident(TG_ARGV[1]);
          fk_name text := quote_ident(TG_ARGV[2]);
          fk_changed boolean := false;
          fk_value integer;
          record record;
        BEGIN
          IF TG_OP = 'UPDATE' THEN
            record := NEW;
            EXECUTE 'SELECT ($1).' || fk_name || ' != ' || '($2).' || fk_name
            INTO fk_changed
            USING OLD, NEW;
          END IF;

          IF TG_OP = 'DELETE' OR fk_changed THEN
            record := OLD;
            EXECUTE 'SELECT ($1).' || fk_name INTO fk_value USING record;
            PERFORM increment_counter(table_name, counter_name, fk_value, -1);
          END IF;

          IF TG_OP = 'INSERT' OR fk_changed THEN
            record := NEW;
            EXECUTE 'SELECT ($1).' || fk_name INTO fk_value USING record;
            PERFORM increment_counter(table_name, counter_name, fk_value, 1);
          END IF;

          RETURN record;
        END;
      $$ LANGUAGE plpgsql;
    SQL

    execute <<-SQL
      CREATE TRIGGER update_category_companies_count  
      AFTER DELETE OR INSERT OR UPDATE ON categories_companies
      FOR EACH ROW EXECUTE PROCEDURE counter_cache('categories', 'companies_count', 'category_id');
    SQL

    execute <<-SQL
      CREATE TRIGGER update_goods_companies_count  
      AFTER DELETE OR INSERT OR UPDATE ON companies_goods
      FOR EACH ROW EXECUTE PROCEDURE counter_cache('goods', 'companies_count', 'good_id');
    SQL
  end
end

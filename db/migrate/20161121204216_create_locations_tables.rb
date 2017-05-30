class CreateLocationsTables < ActiveRecord::Migration[5.0]
  def up
    execute "CREATE SCHEMA locations"
    create_table 'locations.codelists', id: false do |t|
      t.string 'change'
      t.string 'country', foreign_key: 'locations.country_codes.country_code'
      t.string 'location'
      t.string 'name'
      t.string 'name_wo_diactric'
      t.string 'subdivision'
      t.string 'status', foreign_key: 'locations.status_indicators.st_status'
      t.string 'function'
      t.string 'date'
      t.string 'iata'
      t.string 'coordinates'
      t.string 'remarks'
    end

    create_table 'locations.country_codes', id: false do |t|
      t.string 'country_code', primary_key: true, null: false
      t.string 'country_name'
    end

    create_table 'locations.function_classifiers', id: false do |t|
      t.string 'function_code', primary_key: true, null: false
      t.string 'function_description'
    end

    create_table 'locations.status_indicators', id: false do |t|
      t.string 'st_status', primary_key: true, null: false
      t.string 'st_description'
    end

    create_table 'locations.subdivision_codes', id: false  do |t|
      t.string 'su_country', foreign_key: 'locations.country_codes.country_code', null: false
      t.string 'su_code', null: false
      t.string 'su_name'
    end
  end

  def down
    drop_table 'locations.codelists'
    drop_table 'locations.country_codes'
    drop_table 'locations.function_classifiers'
    drop_table 'locations.status_indicators'
    drop_table 'locations.subdivision_codes'

    execute "DROP SCHEMA locations"
  end
end

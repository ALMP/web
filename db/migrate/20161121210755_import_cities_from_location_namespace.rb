class ImportCitiesFromLocationNamespace < ActiveRecord::Migration[5.0]
  def up

    connection = ActiveRecord::Base.connection
    query =<<-SQL
      SELECT name || ', ' ||  locations.country_codes.country_name
        FROM locations.codelists
        JOIN locations.country_codes ON locations.country_codes.country_code = locations.codelists.country
    SQL
    result = connection.execute query
    cities = result.values.map { |line| line[0] }
    progressbar = ProgressBar.create total: cities.count, title: 'Cities', format: '%t %r: |%B %E|'
    if Rails.env.ci? || Rails.env.test?
      cities = []
    end
    cities.each do |city_name|
      City.create! name: city_name
      progressbar.increment
    end
  end

  def down
  end
end

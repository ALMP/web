class ImportLocations < ActiveRecord::Migration[5.0]
  def up
    Locations.import!
  end

  def down
  end
end

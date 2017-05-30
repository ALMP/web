class UpdateCompanyRatings < ActiveRecord::Migration[5.0]
  def up
    Company.all.each &:create_aggregated_rating
    Company.all.each &:reload_rating!
  end
  def down
  end
end

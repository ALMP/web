class MigrateToCounterCulture < ActiveRecord::Migration[5.0]
  def up
    Category.find_each do |category|
      category.update! companies_count: category.companies.count
    end

    Good.find_each do |good|
      good.update! companies_count: good.companies.count
    end
  end

  def down
  end
end

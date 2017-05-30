class CreateAggregatedRatings < ActiveRecord::Migration[5.0]
  def up
    remove_column :companies, :public_reviews_count
    remove_column :companies, :average_rating
    remove_column :companies, :recommended

    create_table :aggregated_ratings do |t|
      t.integer :confirmed_reviews_count, default: 0
      t.references :company, foreign_key: true, index: true
      t.decimal :rating, default: 0
      t.decimal :price, default: 0
      t.decimal :recommended, default: 0
      t.decimal :thankful, default: 0
      t.decimal :quality, default: 0
      t.decimal :payments, default: 0
      t.decimal :stability, default: 0
      t.decimal :service, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :aggregated_ratings
  end
end

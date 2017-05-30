class AddReviewFields < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :rating, :integer
    add_column :reviews, :advantages, :text
    add_column :reviews, :disadvantages, :text
    add_column :reviews, :recommendations, :text
    add_column :reviews, :category, :string

    add_column :reviews, :quality, :integer
    add_column :reviews, :price, :integer
    add_column :reviews, :payments, :integer
    add_column :reviews, :service, :integer
    add_column :reviews, :stability, :integer

    add_column :reviews, :recommended, :boolean
    add_column :reviews, :thankful, :boolean
  end
end

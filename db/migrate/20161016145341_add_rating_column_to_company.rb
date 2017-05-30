# frozen_string_literal: true
class AddRatingColumnToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :public_reviews_count, :integer, default: 0
    add_column :companies, :average_rating, :decimal, default: 0.0
  end
end

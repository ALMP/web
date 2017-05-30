class CreateCustomRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_ratings do |t|
      t.string :title
      t.integer :value, default: 0
      t.references :review, index: true

      t.timestamps
    end
  end
end

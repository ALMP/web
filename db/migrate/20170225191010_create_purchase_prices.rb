class CreatePurchasePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_prices do |t|
      t.string :name
      t.references :company, index: true
      t.string :kind
      t.string :status
      t.references :user, index: true

      t.integer :quantity, default: 0
      t.string :unit

      t.integer :value_cents, limit: 8, default: 0
      t.string :value_currency, default: :usd

      t.timestamps
    end
  end
end

class CreatePublications < ActiveRecord::Migration[5.0]
  def change
    create_table :publications do |t|
      t.string :link
       t.references :company, foreign_key: true
      t.timestamps
    end
  end
end

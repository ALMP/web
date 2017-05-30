class CreateOauthIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :oauth_identities do |t|
      t.string :provider
      t.string :uid
      t.references :user, index: true
      t.jsonb :data

      t.timestamps
    end

    add_column :users, :omniauthable, :boolean, default: false
  end
end

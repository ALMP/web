class AddUserToRevie < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :user_id, :integer, index: true
  end
end

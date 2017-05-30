# frozen_string_literal: true
class AddTypeToUser < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      CREATE TYPE user_role AS ENUM ('User', 'AdminUser');
    SQL
    add_column :users, :type, :user_role, null: false, default: 'User', index: true
  end

  def down
    remove_column :users, :type
    execute <<-SQL
      DROP TYPE user_role;
    SQL
  end
end

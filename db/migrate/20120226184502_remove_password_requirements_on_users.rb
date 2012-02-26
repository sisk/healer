class RemovePasswordRequirementsOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :encrypted_password, :string, :null => true
    change_column :users, :password_salt, :string, :null => true
  end

  def down
    change_column :users, :encrypted_password, :string, :null => false
    change_column :users, :password_salt, :string, :null => false
  end
end
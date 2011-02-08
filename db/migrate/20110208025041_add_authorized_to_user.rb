class AddAuthorizedToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :authorized, :boolean, :default => false
    User.reset_column_information
    User.update_all(:authorized => true)
    add_index :users, :authorized
  end

  def self.down
    remove_index :users, :authorized
    remove_column :users, :authorized
  end
end
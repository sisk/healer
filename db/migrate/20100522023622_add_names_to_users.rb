class AddNamesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name_first, :string, :null => false
    add_column :users, :name_last, :string, :null => false
  end

  def self.down
    remove_column :users, :name_first
    remove_column :users, :name_last
  end
end

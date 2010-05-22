class AddNamesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name_first, :string
    add_column :users, :name_last, :string
  end

  def self.down
    remove_column :users, :name_first
    remove_column :users, :name_last
  end
end

class CompleteBooleanToOperation < ActiveRecord::Migration
  def self.up
    add_column :operations, :complete, :boolean
    add_index :operations, :complete
  end

  def self.down
    remove_index :operations, :complete
    remove_column :operations, :complete
  end
end
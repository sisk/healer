class AddSortOrderToRooms < ActiveRecord::Migration
  def self.up
    add_column :rooms, :display_order, :integer
    add_index :rooms, :display_order
  end

  def self.down
    remove_index :rooms, :display_order
    remove_column :rooms, :display_order
  end
end
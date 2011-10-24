class AddOperatingRoomsToTrip < ActiveRecord::Migration
  def self.up
    add_column :trips, :available_rooms, :integer
    add_column :case_groups, :room_number, :integer
    add_index :case_groups, :room_number
  end

  def self.down
    remove_index :case_groups, :room_number
    remove_column :case_groups, :room_number
    remove_column :trips, :available_rooms
  end
end
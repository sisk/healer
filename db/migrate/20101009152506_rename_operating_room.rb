class RenameOperatingRoom < ActiveRecord::Migration
  def self.up
    rename_table :operating_rooms, :rooms
    rename_column :operations, :operating_room_id, :room_id
  end

  def self.down
    rename_column :operations, :room_id, :operating_room_id
    rename_table :rooms
  end
end

class ProcedureRoomOnRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :room_id, :integer
    add_column :registrations, :schedule_order, :integer
    add_index :registrations, :schedule_order
    remove_column :operations, :schedule_order
  end

  def self.down
    add_column :operations, :schedule_order, :integer
    remove_index :registrations, :schedule_order
    remove_column :registrations, :schedule_order
    remove_column :registrations, :room_id
  end
end

class UserTrips < ActiveRecord::Migration
  def self.up
    rename_column :staff_trips, :staff_id, :user_id
    rename_table :staff_trips, :trips_users
    add_index :trips_users, [:user_id, :trip_id]
  end

  def self.down
    remove_index :trips_users, [:user_id, :trip_id]
    rename_column :staff_trips, :user_id, :staff_id
    rename_table :trips_users, :staff_trips
  end
end
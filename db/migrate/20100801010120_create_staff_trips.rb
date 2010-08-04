class CreateStaffTrips < ActiveRecord::Migration
  def self.up
    create_table :staff_trips, :force => true, :id => false do |t|
      t.integer :staff_id
      t.integer :trip_id
      t.timestamps
    end
  end

  def self.down
    drop_table :staff_trips
  end
end

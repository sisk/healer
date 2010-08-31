class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.integer :patient_id
      t.integer :trip_id
      t.datetime :approved_at
      t.integer :approved_by_id
      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end

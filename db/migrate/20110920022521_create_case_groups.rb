class CreateCaseGroups < ActiveRecord::Migration
  def self.up
    create_table :case_groups do |t|
      t.integer :room_id
      t.integer :trip_id
      t.integer :scheduled_day
      t.integer :schedule_order
      t.timestamps
    end
    add_index :case_groups, :room_id
    add_index :case_groups, :trip_id
    add_index :case_groups, :schedule_order
  end

  def self.down
    remove_index :case_groups, :schedule_order
    remove_index :case_groups, :trip_id
    remove_index :case_groups, :room_id
    drop_table :case_groups
  end
end
class ScheduleOrder < ActiveRecord::Migration
  def self.up
    add_column :operations, :schedule_order, :integer
  end

  def self.down
    remove_column :operations, :schedule_order
  end
end

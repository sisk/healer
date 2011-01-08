class DayToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :scheduled_day, :integer, :default => 0
    add_index :registrations, :scheduled_day
  end

  def self.down
    remove_index :registrations, :scheduled_day
    remove_column :registrations, :scheduled_day
  end
end
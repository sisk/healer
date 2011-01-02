class DailyHoursToTrip < ActiveRecord::Migration
  def self.up
    add_column :trips, :daily_hours, :integer, :default => 8
  end

  def self.down
    remove_column :trips, :daily_hours
  end
end
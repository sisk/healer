class RenameEndOnTrips < ActiveRecord::Migration
  def self.up
    rename_column :trips, :end, :end_date
  end

  def self.down
    rename_column :trips, :end_date, :end
  end
end
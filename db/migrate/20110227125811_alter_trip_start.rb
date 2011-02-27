class AlterTripStart < ActiveRecord::Migration
  def self.up
    rename_column :trips, :start, :start_date
  end

  def self.down
    rename_column :trips, :start_date, :start
  end
end
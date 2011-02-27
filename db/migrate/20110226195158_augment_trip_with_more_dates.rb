class AugmentTripWithMoreDates < ActiveRecord::Migration
  def self.up
    add_column :trips, :procedure_start_date, :date
  end

  def self.down
    remove_column :trips, :procedure_start_date
  end
end
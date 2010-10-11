class JoinTripToFacility < ActiveRecord::Migration
  def self.up
    add_column :trips, :facility_id, :integer
  end

  def self.down
    remove_column :trips, :facility_id
  end
end

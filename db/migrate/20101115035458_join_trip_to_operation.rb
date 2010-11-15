class JoinTripToOperation < ActiveRecord::Migration
  def self.up
    add_column :operations, :trip_id, :integer
  end

  def self.down
    remove_column :operations, :trip_id
  end
end

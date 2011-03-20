class MorePhysicalTherapyMods < ActiveRecord::Migration
  def self.up
    add_column :patient_interactions, :range_of_motion, :boolean
    add_column :patient_interactions, :ambulation, :boolean
  end

  def self.down
    remove_column :patient_interactions, :ambulation
    remove_column :patient_interactions, :range_of_motion
  end
end
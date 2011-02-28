class RenameKneeThickness < ActiveRecord::Migration
  def self.up
    rename_column :implants, :knee_thickness, :tibia_thickness
  end

  def self.down
    rename_column :implants, :tibia_thickness, :knee_thickness
  end
end
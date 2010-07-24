class CreateKneeImplants < ActiveRecord::Migration
  def self.up
    add_column :implants, :femur_diameter, :integer
    add_column :implants, :tibia_diameter, :integer
    add_column :implants, :knee_thickness, :integer
    add_column :implants, :patella_size, :integer
    add_column :implants, :tibia_type, :string
    add_column :implants, :knee_type, :string
    add_column :implants, :patella_resurfaced, :boolean
  end

  def self.down
    remove_column :implants, :femur_diameter
    remove_column :implants, :tibia_diameter
    remove_column :implants, :knee_thickness
    remove_column :implants, :patella_size
    remove_column :implants, :tibia_type
    remove_column :implants, :knee_type
    remove_column :implants, :patella_resurfaced
  end
end

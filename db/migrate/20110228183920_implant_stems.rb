class ImplantStems < ActiveRecord::Migration
  def self.up
    add_column :implants, :femur_stems, :boolean
    add_column :implants, :tibia_stems, :boolean
  end

  def self.down
    remove_column :implants, :tibia_stems
    remove_column :implants, :femur_stems
  end
end
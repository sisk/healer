class ImplantScrews < ActiveRecord::Migration
  def self.up
    add_column :implants, :total_screws, :integer, :default => 0
    add_column :implants, :femur_screws, :integer, :default => 0
    add_column :implants, :tibia_screws, :integer, :default => 0
  end

  def self.down
    remove_column :implants, :tibia_screws
    remove_column :implants, :femur_screws
    remove_column :implants, :total_screws
  end
end
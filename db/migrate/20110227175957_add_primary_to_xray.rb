class AddPrimaryToXray < ActiveRecord::Migration
  def self.up
    add_column :xrays, :primary, :boolean
    add_index :xrays, :primary
  end

  def self.down
    remove_index :xrays, :primary
    remove_column :xrays, :primary
  end
end
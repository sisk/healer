class OperationAnesthesia < ActiveRecord::Migration
  def self.up
    add_column :operations, :anesthesia_type, :string
    add_column :operations, :peripheral_nerve_block_type, :string
  end

  def self.down
    remove_column :operations, :peripheral_nerve_block_type
    remove_column :operations, :anesthesia_type
  end
end
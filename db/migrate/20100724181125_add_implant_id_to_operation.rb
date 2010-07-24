class AddImplantIdToOperation < ActiveRecord::Migration
  def self.up
    add_column :operations, :implant_id, :integer
    remove_column :implants, :operation_id
  end

  def self.down
    add_column :implants, :operation_id, :integer
    remove_column :operations, :implant_id
  end
end

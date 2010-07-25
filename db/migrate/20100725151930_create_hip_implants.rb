class CreateHipImplants < ActiveRecord::Migration
  def self.up
    add_column :implants, :femur_length, :integer
    add_column :implants, :acetabulum_size, :integer
    add_column :implants, :femur_head_size, :integer
    add_column :implants, :neck_length, :integer
  end

  def self.down
    remove_column :implants, :column_name
    remove_column :implants, :column_name
    remove_column :implants, :column_name
    remove_column :implants, :column_name
  end
end

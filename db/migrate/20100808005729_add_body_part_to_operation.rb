class AddBodyPartToOperation < ActiveRecord::Migration
  def self.up
    add_column :operations, :body_part_id, :integer
  end

  def self.down
    remove_column :operations, :body_part_id
  end
end

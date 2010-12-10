class AddOperationTimes < ActiveRecord::Migration
  def self.up
    add_column :operations, :start, :datetime
    add_column :operations, :end, :datetime
  end

  def self.down
    remove_column :operations, :end
    remove_column :operations, :start
  end
end
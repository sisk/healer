class NumberOperationDays < ActiveRecord::Migration
  def self.up
    add_column :trips, :number_of_operation_days, :integer, :default => 3
  end

  def self.down
    remove_column :trips, :number_of_operation_days
  end
end
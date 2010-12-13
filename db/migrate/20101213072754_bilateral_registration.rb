class BilateralRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :likely_bilateral, :boolean, :default => false
    add_index :registrations, :likely_bilateral
  end

  def self.down
    remove_index :registrations, :likely_bilateral
    remove_column :registrations, :likely_bilateral
  end
end
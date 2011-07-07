class RemoveBilateralFromCase < ActiveRecord::Migration
  def self.up
    remove_column :patient_cases, :likely_bilateral
  end

  def self.down
    add_column :patient_cases, :likely_bilateral, :boolean, :default => false
  end
end

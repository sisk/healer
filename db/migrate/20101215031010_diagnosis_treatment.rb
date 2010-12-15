class DiagnosisTreatment < ActiveRecord::Migration
  def self.up
    add_column :diagnoses, :treated, :boolean, :default => false
  end

  def self.down
    remove_column :diagnoses, :treated
  end
end
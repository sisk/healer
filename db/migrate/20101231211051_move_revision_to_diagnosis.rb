class MoveRevisionToDiagnosis < ActiveRecord::Migration
  def self.up
    add_column :diagnoses, :revision, :boolean, :default => false
    remove_column :registrations, :revision
  end

  def self.down
    add_column :registrations, :revision, :boolean
    remove_column :diagnoses, :revision
  end
end

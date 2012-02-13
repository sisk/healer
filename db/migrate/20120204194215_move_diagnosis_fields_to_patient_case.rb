class MoveDiagnosisFieldsToPatientCase < ActiveRecord::Migration
  def up
    add_column :patient_cases, :disease_id, :integer
    add_column :patient_cases, :severity, :integer, :default => 0
    add_column :patient_cases, :revision, :boolean, :default => false
    add_column :patient_cases, :body_part_id, :integer
    add_index :patient_cases, :disease_id
    add_index :patient_cases, :revision
    add_index :patient_cases, :body_part_id
  end

  def down
    remove_column :patient_cases, :disease_id
    remove_column :patient_cases, :severity
    remove_column :patient_cases, :revision
    remove_column :patient_cases, :body_part_id
  end
end
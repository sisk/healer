class RenameRegistrationToCase < ActiveRecord::Migration
  def self.up
    rename_table :registrations, :patient_cases
    rename_column :diagnoses, :registration_id, :patient_case_id
    rename_column :operations, :registration_id, :patient_case_id
    rename_column :patient_interactions, :registration_id, :patient_case_id
  end

  def self.down
    rename_column :patient_interactions, :patient_case_id, :registration_id
    rename_column :operations, :patient_case_id
    rename_column :diagnoses, :patient_case_id, :registration_id
    rename_table :patient_cases, :registrations
  end
end
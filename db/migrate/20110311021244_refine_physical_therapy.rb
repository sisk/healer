class RefinePhysicalTherapy < ActiveRecord::Migration
  def self.up
    add_column :patient_interactions, :registration_id, :integer
    add_index :patient_interactions, :registration_id
    add_column :patient_interactions, :additional_assistance, :boolean
    remove_column :patient_interactions, :number_of_assistances
    remove_column :patient_interactions, :walker_used
    rename_column :patient_interactions, :extension, :knee_extension
    rename_column :patient_interactions, :flexion, :knee_flexion
    add_column :patient_interactions, :severe_pain, :boolean
    rename_column :patient_interactions, :abduction, :hip_abduction
  end

  def self.down
    rename_column :patient_interactions, :hip_abduction, :abduction
    remove_column :patient_interactions, :severe_pain
    rename_column :patient_interactions, :new_column_name, :column_name
    rename_column :patient_interactions, :knee_extension, :extension
    rename_column :patient_interactions, :knee_flexion, :flexion
    add_column :patient_interactions, :walker_used, :boolean
    add_column :patient_interactions, :number_of_assistances, :integer
    remove_column :patient_interactions, :additional_assistance
    remove_index :patient_interactions, :registration_id
    remove_column :patient_interactions, :registration_id
  end
end
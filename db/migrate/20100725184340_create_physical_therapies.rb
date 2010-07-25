class CreatePhysicalTherapies < ActiveRecord::Migration
  def self.up
    add_column :patient_interactions, :distance_walked, :string
    add_column :patient_interactions, :number_of_assistances, :integer
    add_column :patient_interactions, :walker_used, :boolean
    add_column :patient_interactions, :extension, :string
    add_column :patient_interactions, :flexion, :string
    add_column :patient_interactions, :abduction, :string
  end

  def self.down
    remove_column :patient_interactions, :distance_walked
    remove_column :patient_interactions, :number_of_assistances
    remove_column :patient_interactions, :walker_used
    remove_column :patient_interactions, :extension
    remove_column :patient_interactions, :flexion
    remove_column :patient_interactions, :abduction
  end
end

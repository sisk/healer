class AddTypeToPatientInteraction < ActiveRecord::Migration
  def self.up
    add_column :patient_interactions, :type, :string
  end

  def self.down
    remove_column :patient_interactions, :type
  end
end

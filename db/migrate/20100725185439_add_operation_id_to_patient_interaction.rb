class AddOperationIdToPatientInteraction < ActiveRecord::Migration
  def self.up
    add_column :patient_interactions, :operation_id, :integer
  end

  def self.down
    remove_column :patient_interactions, :operation_id
  end
end

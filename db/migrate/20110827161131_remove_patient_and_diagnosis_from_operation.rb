class RemovePatientAndDiagnosisFromOperation < ActiveRecord::Migration
  def self.up
    remove_column :operations, :patient_id
    remove_column :operations, :diagnosis_id
    remove_column :operations, :body_part_id
    remove_column :operations, :trip_id
  end

  def self.down
    add_column :operations, :trip_id, :integer
    add_column :operations, :body_part_id, :integer
    add_column :operations, :diagnosis_id, :integer
    add_column :operations, :patient_id, :integer
  end
end

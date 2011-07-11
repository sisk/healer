class MigrateXraysToPatientCase < ActiveRecord::Migration
  def self.up
    add_column :xrays, :patient_case_id, :integer
    add_index :xrays, :patient_case_id
    Xray.reset_column_information
    Xray.find(:all, :conditions => ["xrays.operation_id is not ?", nil]).each do |xray|
      xray.update_attributes(:patient_case_id => xray.operation.try(:patient_case_id))
    end
  end

  def self.down
    remove_index :xrays, :patient_case_id
    remove_column :xrays, :patient_case_id
  end
end
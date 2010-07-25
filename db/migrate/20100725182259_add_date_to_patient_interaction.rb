class AddDateToPatientInteraction < ActiveRecord::Migration
  def self.up
    add_column :patient_interactions, :date_time, :datetime
  end

  def self.down
    remove_column :table_name, :date_time
  end
end

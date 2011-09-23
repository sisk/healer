class AddCaseGroupIdToCase < ActiveRecord::Migration
  def self.up
    add_column :patient_cases, :case_group_id, :integer
    add_index :patient_cases, :case_group_id
  end

  def self.down
    remove_index :patient_cases, :case_group_id
    remove_column :patient_cases, :case_group_id
  end
end
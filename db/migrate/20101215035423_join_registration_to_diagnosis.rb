class JoinRegistrationToDiagnosis < ActiveRecord::Migration
  def self.up
    add_column :diagnoses, :registration_id, :integer
  end

  def self.down
    remove_column :diagnoses, :registration_id
  end
end
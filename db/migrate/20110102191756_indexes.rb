class Indexes < ActiveRecord::Migration
  def self.up
    add_index :risk_factors, :patient_id
    add_index :registrations, :trip_id
    add_index :roles_users, :user_id
    add_index :xrays, :diagnosis_id
    add_index :registrations, [:trip_id, :approved_at]
    add_index :diagnoses, :registration_id
    # add_index :patients, [:name_last, :name_first]
  end

  def self.down
    # remove_index :patients, [:name_last, :name_first]
    remove_index :diagnoses, :registration_id
    remove_index :registrations, [:trip_id, :approved_at]
    remove_index :xrays, :diagnosis_id
    remove_index :roles_users, :user_id
    remove_index :registrations, :trip_id
    remove_index :risk_factors, :patient_id
  end
end
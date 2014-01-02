class RenameCaseGroupsToAppointments < ActiveRecord::Migration
  def self.up
    remove_index :case_groups, :room_id
    remove_index :case_groups, :room_number
    remove_index :case_groups, :schedule_order
    remove_index :case_groups, :trip_id
    rename_table :case_groups, :appointments
    add_index :appointments, :room_id
    add_index :appointments, :room_number
    add_index :appointments, :schedule_order
    add_index :appointments, :trip_id

    remove_index :patient_cases, :case_group_id
    rename_column :patient_cases, :case_group_id, :appointment_id
    add_index :patient_cases, :appointment_id
  end

  def self.down
    remove_index :appointments, :room_id
    remove_index :appointments, :room_number
    remove_index :appointments, :schedule_order
    remove_index :appointments, :trip_id
    rename_table :appointments, :case_groups
    add_index :case_groups, :room_id
    add_index :case_groups, :room_number
    add_index :case_groups, :schedule_order
    add_index :case_groups, :trip_id

    remove_index :patient_cases, :appointment_id
    rename_column :patient_cases, :appointment_id, :case_group_id
    add_index :patient_cases, :case_group_id
  end
end
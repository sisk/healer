class RemoveOldFieldsFromPatientCases < ActiveRecord::Migration
  def self.up
    remove_column :patient_cases, :checkin_at
    remove_column :patient_cases, :checkout_at
    remove_column :patient_cases, :location
    remove_column :patient_cases, :room_id
    remove_column :patient_cases, :schedule_order
    remove_column :patient_cases, :scheduled_day
  end

  def self.down
    add_column :patient_cases, :scheduled_day, :integer
    add_column :patient_cases, :schedule_order, :integer
    add_column :patient_cases, :room_id, :integer
    add_column :patient_cases, :location, :string
    add_column :patient_cases, :checkout_at, :datetime
    add_column :patient_cases, :checkin_at, :datetime
  end
end

class AddAnatomyToPatientCases < ActiveRecord::Migration
  def change
    add_column :patient_cases, :anatomy, :string
    add_column :patient_cases, :side, :string
    add_index :patient_cases, :anatomy
  end
end

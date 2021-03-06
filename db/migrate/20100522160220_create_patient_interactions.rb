class CreatePatientInteractions < ActiveRecord::Migration
  def self.up
    create_table :patient_interactions do |t|
      t.integer :patient_id, :null => false
      t.integer :provider_id
      t.text :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :patient_interactions
  end
end

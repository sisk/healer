class CreateDiagnoses < ActiveRecord::Migration
  def self.up
    create_table :diagnoses do |t|
      t.integer :patient_id
      t.integer :body_part_id
      t.integer :disease_id
      t.integer :severity, :default => 0
      t.date :assessed_date

      t.timestamps
    end
  end

  def self.down
    drop_table :diagnoses
  end
end

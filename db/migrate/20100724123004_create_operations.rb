class CreateOperations < ActiveRecord::Migration
  def self.up
    create_table :operations do |t|
      t.integer :procedure_id
      t.integer :patient_id
      t.integer :primary_surgeon_id
      t.integer :secondary_surgeon_id
      t.integer :anesthesiologist_id
      t.integer :diagnosis_id
      t.date :date
      t.string :approach
      t.integer :difficulty, :default => 0
      t.string :side
      t.boolean :graft
      t.text :notes
      t.string :ambulatory_order

      t.timestamps
    end
  end

  def self.down
    drop_table :operations
  end
end

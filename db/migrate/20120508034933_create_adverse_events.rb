class CreateAdverseEvents < ActiveRecord::Migration
  def change
    create_table :adverse_events do |t|
      t.integer :patient_id, :null => false
      t.integer :case_id
      t.integer :entered_by_id
      t.text :reason
      t.text :note
      t.timestamps
    end

    add_index :adverse_events, :patient_id
    add_index :adverse_events, :case_id
  end
end

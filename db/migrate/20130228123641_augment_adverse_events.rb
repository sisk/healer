class AugmentAdverseEvents < ActiveRecord::Migration
  def change
    add_column :adverse_events, :date_of_occurrence, :date
    change_column :adverse_events, :reason, :string, :null => true
    rename_column :adverse_events, :reason, :event_type
    add_index :adverse_events, :case_id
  end
end

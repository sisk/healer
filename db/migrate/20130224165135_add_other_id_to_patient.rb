class AddOtherIdToPatient < ActiveRecord::Migration
  def change
  	add_column :patients, :other_id, :string
  end
end

class AdditionalPatientFields < ActiveRecord::Migration
  def self.up
    add_column :patients, :medications, :text
    add_column :patients, :other_diseases, :text
  end

  def self.down
    remove_column :patients, :other_diseases
    remove_column :patients, :medications
  end
end

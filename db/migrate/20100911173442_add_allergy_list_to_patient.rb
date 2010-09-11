class AddAllergyListToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :allergies, :text
  end

  def self.down
    remove_column :patients, :allergies
  end
end

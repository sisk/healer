class DropPatientNameFragments < ActiveRecord::Migration
  def up
    remove_column :patients, :name_first
    remove_column :patients, :name_last
    remove_column :patients, :name_middle
  end

  def down
    add_column :patients, :name_first, :string, :null => true
    add_column :patients, :name_last, :string, :null => true
    add_column :patients, :name_middle, :string, :null => true
    add_index :patients, [:name_first, :name_middle, :name_last]
  end
end

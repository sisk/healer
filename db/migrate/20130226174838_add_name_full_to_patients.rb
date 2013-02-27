class AddNameFullToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :name_full, :string
    add_index :patients, [:name_full]
    add_index :patients, [:name_full, :country]
  end
end

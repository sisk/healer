class AddEmailToPatient < ActiveRecord::Migration
  def self.up
    add_column :patients, :email, :string
  end

  def self.down
    remove_column :patients, :email
  end
end

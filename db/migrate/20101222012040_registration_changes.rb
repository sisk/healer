class RegistrationChanges < ActiveRecord::Migration
  def self.up
    add_column :registrations, :revision, :boolean
    add_column :registrations, :complexity, :integer
    add_column :trips, :complexity_minutes, :integer, :default => 30, :null => false
  end

  def self.down
    remove_column :trips, :complexity_minutes
    remove_column :registrations, :complexity
    remove_column :registrations, :revision
  end
end
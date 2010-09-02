class AddCreatedByToRegistration < ActiveRecord::Migration
  def self.up
    add_column :registrations, :created_by_id, :integer
  end

  def self.down
    remove_column :registrations, :created_by_id
  end
end

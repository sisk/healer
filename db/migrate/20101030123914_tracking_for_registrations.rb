class TrackingForRegistrations < ActiveRecord::Migration
  def self.up
    add_column :registrations, :checkin_at, :datetime
    add_column :registrations, :checkout_at, :datetime
    add_column :registrations, :status, :string
    add_column :registrations, :location, :string
    add_column :operations, :registration_id, :integer
  end

  def self.down
    remove_column :registrations, :status
    remove_column :registrations, :location
    remove_column :operations, :registration_id
    remove_column :registrations, :checkout_at
    remove_column :registrations, :checkin_at
  end
end

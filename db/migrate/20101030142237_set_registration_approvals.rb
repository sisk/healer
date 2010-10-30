class SetRegistrationApprovals < ActiveRecord::Migration
  def self.up
    Registration.update_all("status = 'Registered'", "registrations.approved_at is not NULL")
    Registration.update_all("status = 'Pre-Screen'", "registrations.approved_at is NULL")
  end

  def self.down
    Registration.update_all("status = NULL")
  end
end

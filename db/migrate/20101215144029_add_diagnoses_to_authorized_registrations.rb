class AddDiagnosesToAuthorizedRegistrations < ActiveRecord::Migration
  class Registration < ActiveRecord::Base
    belongs_to :patient
    has_many :diagnoses
    scope :authorized, :conditions => [ "registrations.approved_at is not ?", nil ]
  end
  
  def self.up
    Registration.authorized.each do |registration|
      registration.diagnoses = registration.patient.diagnoses.untreated
      registration.save
    end
  end

  def self.down
    Registration.authorized.each do |registration|
      registration.diagnoses.clear
      registration.save
    end
  end
end

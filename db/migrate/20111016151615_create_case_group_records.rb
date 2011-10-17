class CreateCaseGroupRecords < ActiveRecord::Migration

  class PatientCase < ActiveRecord::Base; end

  def self.up
    PatientCase.authorized.each{ |pc| pc.save }
  end

  def self.down
  end
end

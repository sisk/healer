class CreateCaseGroupRecords < ActiveRecord::Migration

  # class PatientCase < ActiveRecord::Base
  #   scope :authorized, where("patient_cases.approved_at is not ?", nil)
  # end
  #
  def self.up
    PatientCase.all.each{ |pc| pc.save }
  end

  def self.down
  end

end

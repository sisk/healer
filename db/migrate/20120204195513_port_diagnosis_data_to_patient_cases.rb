class PortDiagnosisDataToPatientCases < ActiveRecord::Migration

  class Diagnosis < ActiveRecord::Base
    belongs_to :patient_case
  end

  class PatientCase < ActiveRecord::Base
    has_one :diagnosis, :dependent => :destroy
  end

  def up
    Diagnosis.all.each do |diagnosis|
      if diagnosis.patient_case.present?
        diagnosis.patient_case.update_attributes({
          :disease_id => diagnosis.disease_id,
          :severity => diagnosis.severity,
          :revision => diagnosis.revision,
          :body_part_id => diagnosis.body_part_id
        })
      end
    end
  end

  def down
  end
end

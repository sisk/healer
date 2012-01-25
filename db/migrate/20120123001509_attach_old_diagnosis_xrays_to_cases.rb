class AttachOldDiagnosisXraysToCases < ActiveRecord::Migration

  class Xray < ActiveRecord::Base
    belongs_to :diagnosis # 2011-07-10 marked for death when case transition complete
  end
  class PatientCase < ActiveRecord::Base; end
  class Diagnosis < ActiveRecord::Base
    belongs_to :patient_case
  end

  def up
    Xray.find(:all, :conditions => ["patient_case_id is ? and diagnosis_id is not ?", nil, nil]).each do |xray|
      xray.update_attributes(:patient_case_id => xray.diagnosis.try(:patient_case_id), :primary => 0)
    end
  end

  def down
  end
end

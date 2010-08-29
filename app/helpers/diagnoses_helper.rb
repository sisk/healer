module DiagnosesHelper

  def date_assessed(diagnosis)
    diagnosis.assessed_date.kind_of?(Date) ? "#{diagnosis.assessed_date}" : "Unknown"
  end

  def severity(diagnosis)
    Diagnosis.severity_table[diagnosis.severity]
  end

end

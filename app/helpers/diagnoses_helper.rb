module DiagnosesHelper
  def date_assessed(diagnosis)
    diagnosis.assessed_date.kind_of?(Date) ? "assessed #{diagnosis.assessed_date}" : "unknown assessment date"
  end
end

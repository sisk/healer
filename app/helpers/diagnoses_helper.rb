module DiagnosesHelper

  def date_assessed(diagnosis)
    diagnosis.assessed_date.kind_of?(Date) ? "#{diagnosis.assessed_date}" : "Unknown"
  end

  def severity(diagnosis)
    Diagnosis.severity_table[diagnosis.severity]
  end
  
  def formatted_title(diagnosis)
    str = "<h4>#{diagnosis.disease.to_s}</h4>"
    return diagnosis.body_part.present? ? "<h3>#{diagnosis.body_part.to_s}</h3>" + str : str
  end

end

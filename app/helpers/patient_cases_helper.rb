module PatientCasesHelper

  def severity(c)
    PatientCase.severity_table[c.severity]
  end

end

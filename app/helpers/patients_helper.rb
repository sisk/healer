module PatientsHelper
  
  def patient_image(patient)
    if patient.photo.file?
      image_tag(patient.photo.url(:thumb), :alt => "Photo of #{patient.to_s}")
    else
      image_file = (patient.male.nil? || patient.male?) ? "male-generic.gif" : "female-generic.gif"
      image_tag(image_file, :alt => "")
    end
  end

  def patient_gender(patient)
    case patient.male
    when true then "Male"
    when false then "Female"
    else "Unknown"
    end
  end
  
  def risk_factor_list(patient)
    patient.risk_factors.collect{ |rf| rf.to_s }.join(", ")
  end
  
end

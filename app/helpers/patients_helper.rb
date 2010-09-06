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

  def free_text_list_to_array(str)
    return [] if str.to_s.chomp.blank?
    return str.split(/,|\n|\r/m).reject{ |v| v.blank? }.collect{ |v| v.strip }
  end
  
  def birth_date_and_age(patient)
    return "Unknown" if patient.birth.blank?
    day_diff = Time.now.day - patient.birth.day
    month_diff = Time.now.month - patient.birth.month - (day_diff < 0 ? 1 : 0)
    age = Time.now.year - patient.birth.year - (month_diff < 0 ? 1 : 0)
    return "#{patient.birth} (Age #{age})"
  end

end

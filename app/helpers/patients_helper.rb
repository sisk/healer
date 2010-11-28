module PatientsHelper
  
  def patient_image(patient, size = :thumb)
    image_tag(patient.displayed_photo(size), :alt => "Photo of #{patient.to_s}")
  end

  def patient_gender(patient)
    case patient.try(:male)
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
    return "Unknown" if patient.try(:birth).blank?
    day_diff = Time.now.day - patient.birth.day
    month_diff = Time.now.month - patient.birth.month - (day_diff < 0 ? 1 : 0)
    age = Time.now.year - patient.birth.year - (month_diff < 0 ? 1 : 0)
    return "#{patient.birth} (Age #{age})"
  end
  
  def patient_height(patient, us = false)
    return "Unknown" if patient.height_cm.blank?
    return "#{patient.height_cm} cm" if us == false
    raw_conversion = patient.height_cm * 0.393700787
    the_round = (raw_conversion * 100).round.to_f / 100
    return "#{the_round} in"
  end
  def patient_weight(patient, us = false)
    return "Unknown" if patient.weight_kg.blank?
    return "#{patient.weight_kg} kg" if us == false
    raw_conversion = patient.weight_kg * 2.20462262
    the_round = (raw_conversion * 100).round.to_f / 100
    return "#{the_round} lb"
  end

end

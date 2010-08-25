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
  
end

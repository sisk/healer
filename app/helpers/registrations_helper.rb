module RegistrationsHelper
  
  def body_part_list(registration)
    registration.diagnoses.map(&:body_part).map(&:to_s).join(", ")
  end
  
end

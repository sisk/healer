class PatientInteraction < ActiveRecord::Base
  belongs_to :provider, :class_name => "User", :foreign_key => "provider_id"
  belongs_to :patient, :class_name => "User", :foreign_key => "patient_id"
end

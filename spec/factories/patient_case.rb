FactoryGirl.define do
  factory :patient_case do
    patient
    trip
  end

  factory :left_knee_case, class: PatientCase do
  end
end

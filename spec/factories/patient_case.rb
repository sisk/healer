FactoryGirl.define do
  factory :patient_case do
    association :patient, factory: :patient
  end

  factory :left_knee_case, class: PatientCase do
  end
end

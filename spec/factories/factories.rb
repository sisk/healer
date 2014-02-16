include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :adverse_event do
  end
end

FactoryGirl.define do
  factory :implant do
    type "Implant"
    operation
  end

  factory :knee_implant, class: Implant do
    type "KneeImplant"
  end

  factory :hip_implant, class: Implant do
    type "HipImplant"
  end
end

FactoryGirl.define do
  factory :operation do
    patient_case
    procedure
  end
end

FactoryGirl.define do
  factory :patient do
    name_full "Arturo Andrew Amos"
  end
end

FactoryGirl.define do
  factory :patient_case do
    patient
    trip
  end

  factory :left_knee_case, class: PatientCase do
  end
end

FactoryGirl.define do
  factory :procedure do
    sequence(:name_en) { |n| "TKR_#{n}" }
  end
end

FactoryGirl.define do
  factory :role do
    name "derp"
  end

  factory :role_admin, class: Role do
    name "administrator"
  end
  factory :role_doctor, class: Role do
    name "doctor"
  end
  factory :role_nurse, class: Role do
    name "nurse"
  end
end

FactoryGirl.define do
  factory :trip do
    sequence(:nickname) { |n| "gt_test_#{n}" }
    country "GT"
    start_date Time.now
  end
end

FactoryGirl.define do
  factory :user do
    name_first 'Aaron'
    name_last 'Aaronson'
    email 'aaron@aaron.com'
    password 'blahblah'
  end

  factory :user_admin, class: User do
    name_first 'Alice'
    name_last 'Admin'
    roles {|roles| [roles.association(:role_admin)]}
  end
  factory :user_doctor, class: User do
    name_first 'Dan'
    name_last 'Doctor'
    roles {|roles| [roles.association(:role_doctor)]}
  end
  factory :user_nurse, class: User do
    name_first 'Norbert'
    name_last 'Nurse'
    roles {|roles| [roles.association(:role_nurse)]}
  end
end

FactoryGirl.define do
  factory :xray do
    patient_case
    photo { fixture_file_upload( "spec/factories/single_pixel.png", "image/png") }
  end

  factory :pre_op_xray, class: Xray do
    patient_case
    photo { fixture_file_upload( "spec/factories/single_pixel.png", "image/png") }
  end

  factory :post_op_xray, class: Xray do
    patient_case
    operation
    photo { fixture_file_upload( "spec/factories/single_pixel.png", "image/png") }
  end
end
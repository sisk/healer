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

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

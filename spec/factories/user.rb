Factory.define :user do |u|
  u.name_first 'Aaron'
  u.name_last 'Aaronson'
  u.email 'aaron@aaron.com'
  u.password 'blahblah'
end

Factory.define :user_admin, :parent => :user do |f|
  f.roles {|roles| [roles.association(:role_admin)]}
end
Factory.define :user_doctor, :parent => :user do |f|
  f.roles {|roles| [roles.association(:role_doctor)]}
end
Factory.define :user_nurse, :parent => :user do |f|
  f.roles {|roles| [roles.association(:role_nurse)]}
end

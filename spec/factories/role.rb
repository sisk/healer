Factory.define :role do |f|
  f.name "derp"
end

Factory.define :role_admin, :class => Role do |f|
  f.name "operator"
end
Factory.define :role_doctor, :class => Role do |f|
  f.name "doctor"
end
Factory.define :role_nurse, :class => Role do |f|
  f.name "nurse"
end

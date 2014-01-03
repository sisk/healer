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

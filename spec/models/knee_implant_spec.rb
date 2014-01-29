require 'spec_helper'

describe KneeImplant do
  it "is a kind of Implant" do
    KneeImplant.new.should be_a_kind_of(Implant)
  end
end

describe KneeImplant, ".desired_attributes" do
  it "returns an array of attributes" do
    KneeImplant::desired_attributes.should == [:femur_diameter,:tibia_diameter,:tibia_thickness,:patella_size,:tibia_type,:knee_type]
  end
end
require 'spec_helper'

describe HipImplant do
  it "is a kind of Implant" do
    HipImplant.new.should be_a_kind_of(Implant)
  end
end

describe HipImplant, ".desired_attributes" do
  it "returns an array of attributes" do
    HipImplant::desired_attributes.should == [:femur_diameter, :femur_length, :acetabulum_size, :femur_head_size, :neck_length, :prosthesis_type]
  end
end
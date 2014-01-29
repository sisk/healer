require 'spec_helper'

describe KneeImplant do
  it "is a kind of Implant" do
    KneeImplant.new.should be_a_kind_of(Implant)
  end
end

describe KneeImplant, ".patella_sizes" do
  it "returns an indexed hash of the expected values" do
    KneeImplant::patella_sizes.should == { 0 => "Small", 1 => "Medium", 2 => "Large" }
  end
end

describe KneeImplant, ".femur_diameters" do
  it "returns an array of the expected values" do
    KneeImplant::femur_diameters.should == [55,60,65,70,75,80,85]
  end
end

describe KneeImplant, ".tibia_diameters" do
  it "returns an array of the expected values" do
    KneeImplant::tibia_diameters.should == [60,65,70,75,80]
  end
end

describe KneeImplant, ".tibia_thicknesses" do
  it "returns an array of the expected values" do
    KneeImplant::tibia_thicknesses.should == [10,12,14,16,20,22]
  end
end

describe KneeImplant, ".tibia_types" do
  it "returns an array of the expected values" do
    KneeImplant::tibia_types.should == ["Metal-backed"]
  end
end

describe KneeImplant, ".knee_types" do
  it "returns an array of the expected values" do
    KneeImplant::knee_types.should == ["CR","PS","CC","Hinge"]
  end
end

describe KneeImplant, ".desired_attributes" do
  it "returns an array of attributes" do
    KneeImplant::desired_attributes.should == [:femur_diameter,:tibia_diameter,:tibia_thickness,:patella_size,:tibia_type,:knee_type]
  end
end
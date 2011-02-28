require 'spec_helper'

describe KneeImplant do
  it "is a kind of Implant" do
    KneeImplant.new.should be_a_kind_of(Implant)
  end
  should_have_column :femur_diameter, :type => :integer
  should_have_column :tibia_diameter, :type => :integer
  should_have_column :tibia_thickness, :type => :integer
  should_have_column :patella_size, :type => :integer
  should_have_column :tibia_type, :type => :string
  should_have_column :knee_type, :type => :string

  should_have_column :patella_resurfaced, :type => :boolean
  should_have_column :femur_screws, :type => :integer
  should_have_column :tibia_screws, :type => :integer
  should_have_column :femur_stems, :type => :boolean
  should_have_column :tibia_stems, :type => :boolean

  should_validate_numericality_of :femur_diameter, :allow_blank => true
  should_validate_numericality_of :tibia_diameter, :allow_blank => true
  should_validate_numericality_of :tibia_thickness, :allow_blank => true
  should_validate_numericality_of :patella_size, :allow_blank => true

  should_validate_inclusion_of :femur_diameter, :in => KneeImplant::femur_diameters, :allow_blank => true
  should_validate_inclusion_of :tibia_type, :in => KneeImplant::tibia_types, :allow_blank => true
  should_validate_inclusion_of :tibia_diameter, :in => KneeImplant::tibia_diameters, :allow_blank => true
  should_validate_inclusion_of :tibia_thickness, :in => KneeImplant::tibia_thicknesses, :allow_blank => true
  should_validate_inclusion_of :patella_size, :in => KneeImplant::patella_sizes.keys, :allow_blank => true
  should_validate_inclusion_of :knee_type, :in => KneeImplant::knee_types, :allow_blank => true

end

describe KneeImplant, ".patella_sizes" do
  it "returns an indexed hash of the expected values" do
    KneeImplant::patella_sizes.should == { 0 => "Small", 1 => "Medium", 2 => "Large" }
  end
end

describe KneeImplant, ".femur_diameters" do
  it "returns an array of the expected values" do
    KneeImplant::femur_diameters.should == [60,65,70,75,80,85]
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
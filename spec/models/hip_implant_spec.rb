require 'spec_helper'

describe HipImplant do
  it "is a kind of Implant" do
    HipImplant.new.should be_a_kind_of(Implant)
  end
  should_have_column :femur_diameter, :type => :integer
  should_have_column :femur_length, :type => :integer
  should_have_column :acetabulum_size, :type => :integer
  should_have_column :femur_head_size, :type => :integer
  should_have_column :neck_length, :type => :integer
  should_have_column :prosthesis_type, :type => :string

  should_validate_numericality_of :femur_diameter, :allow_blank => false
  should_validate_numericality_of :femur_length, :allow_blank => false
  should_validate_numericality_of :acetabulum_size, :allow_blank => false
  should_validate_numericality_of :femur_head_size, :allow_blank => false
  should_validate_numericality_of :neck_length, :allow_blank => false

  should_validate_inclusion_of :femur_diameter, :in => HipImplant::femur_diameters, :allow_blank => false
  should_validate_inclusion_of :femur_length, :in => HipImplant::femur_lengths, :allow_blank => false
  should_validate_inclusion_of :acetabulum_size, :in => HipImplant::acetabulum_sizes, :allow_blank => false
  should_validate_inclusion_of :femur_head_size, :in => HipImplant::femur_head_sizes, :allow_blank => false
  should_validate_inclusion_of :neck_length, :in => HipImplant::neck_lengths, :allow_blank => false
  
  should_validate_presence_of :prosthesis_type
  should_validate_presence_of :femur_length
  should_validate_presence_of :acetabulum_size
  should_validate_presence_of :femur_head_size
  should_validate_presence_of :neck_length
  should_validate_presence_of :femur_diameter

end

describe HipImplant, ".femur_diameters" do
  it "returns an array of the expected values" do
    HipImplant::femur_diameters.should == [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21]
  end
end

describe HipImplant, ".femur_lengths" do
  it "returns an array of the expected values" do
    HipImplant::femur_lengths.should == [105,110,115,120,125,130,135,140,145,150,155,160,165,170,175,180,185,200,220,240]
  end
end

describe HipImplant, ".acetabulum_sizes" do
  it "returns an array of the expected values" do
    HipImplant::acetabulum_sizes.should == [46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80]
  end
end

describe HipImplant, ".femur_head_sizes" do
  it "returns an array of the expected values" do
    HipImplant::femur_head_sizes.should == [22,26,28,30,32,36,40,44]
  end
end

describe HipImplant, ".neck_lengths" do
  it "returns an array of the expected values" do
    HipImplant::neck_lengths.should == [-6,-3,0,3,6,9,12]
  end
end

describe HipImplant, ".prosthesis_types" do
  it "returns an array of the expected values" do
    HipImplant::prosthesis_types.should == ["bimetric","calcar","taperloc"]
  end
end

describe HipImplant, ".desired_attributes" do
  it "returns an array of attributes" do
    HipImplant::desired_attributes.should == [:femur_diameter, :femur_length, :acetabulum_size, :femur_head_size, :neck_length, :prosthesis_type]
  end
end
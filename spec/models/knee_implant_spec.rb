require 'spec_helper'

describe KneeImplant do
  it "is a kind of Implant" do
    KneeImplant.new.should be_a_kind_of(Implant)
  end
  should_have_column :femur_diameter, :type => :integer
  should_have_column :tibia_diameter, :type => :integer
  should_have_column :knee_thickness, :type => :integer
  should_have_column :patella_size, :type => :integer
  should_have_column :tibia_type, :type => :string
  should_have_column :knee_type, :type => :string
  should_have_column :patella_resurfaced, :type => :boolean

  should_validate_numericality_of :femur_diameter, :allow_nil => true
  should_validate_numericality_of :tibia_diameter, :allow_nil => true
  should_validate_numericality_of :knee_thickness, :allow_nil => true
  should_validate_numericality_of :patella_size, :allow_nil => true

  should_validate_inclusion_of :femur_diameter, :in => [60,65,70,75,80,85], :allow_nil => true
  should_validate_inclusion_of :tibia_type, :in => ["Metal-backed"], :allow_nil => true
  should_validate_inclusion_of :tibia_diameter, :in => [60,65,70,75,80], :allow_nil => true
  should_validate_inclusion_of :knee_thickness, :in => [10,12,14,16,20,22], :allow_nil => true
  should_validate_inclusion_of :patella_size, :in => KneeImplant::patella_sizes.keys, :allow_nil => true
  should_validate_inclusion_of :knee_type, :in => ["CR","PS","CC","Hinge"], :allow_nil => true

end

describe KneeImplant, ".patella_sizes" do
  it "returns an indexed hash of the expected values" do
    KneeImplant::patella_sizes.should == { 0 => "Small", 1 => "Medium", 2 => "Large" }
  end
end

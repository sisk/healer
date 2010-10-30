require 'spec_helper'

describe Operation do
  should_have_column :procedure_id, :type => :integer
  should_have_column :patient_id, :type => :integer
  should_have_column :diagnosis_id, :type => :integer
  should_have_column :body_part_id, :type => :integer
  should_have_column :primary_surgeon_id, :type => :integer
  should_have_column :secondary_surgeon_id, :type => :integer
  should_have_column :anesthesiologist_id, :type => :integer
  should_have_column :date, :type => :date
  should_have_column :approach, :type => :string
  should_have_column :difficulty, :type => :integer, :default => 0
  should_have_column :graft, :type => :boolean
  should_have_column :notes, :type => :text
  should_have_column :ambulatory_order, :type => :string
  should_have_column :room_id, :type => :integer
  should_have_column :registration_id, :type => :integer

  should_belong_to :procedure
  should_belong_to :patient
  should_belong_to :diagnosis
  should_belong_to :body_part
  should_belong_to :primary_surgeon
  should_belong_to :secondary_surgeon
  should_belong_to :anesthesiologist
  should_belong_to :room
  should_belong_to :registration

  should_have_one :implant
  should_have_one :knee_implant
  should_have_one :hip_implant

  should_have_many :xrays

  should_validate_presence_of :procedure
  should_validate_presence_of :patient
  should_validate_presence_of :body_part
  should_validate_presence_of :date

  should_validate_numericality_of :difficulty
  should_validate_inclusion_of :difficulty, :in => Operation::difficulty_table.keys
  
  should_validate_inclusion_of :approach, :in => Operation::approaches, :allow_nil => true, :allow_blank => true
  should_validate_inclusion_of :ambulatory_order, :in => Operation::ambulatory_orders, :allow_nil => true, :allow_blank => true
  
end

describe Operation, ".approaches" do
  it "returns an array of the expected values" do
    Operation::approaches.should == ["Anterior","Lateral","Medial","Posterior","Dorsal","Lateral Transfibular"]
  end
end
describe Operation, ".ambulatory_orders" do
  it "returns an array of the expected values" do
    Operation::ambulatory_orders.should == ["Weight Bearing as Tolerated","Non-Weight Bearing","Partial Weight Bearing"]
  end
end
describe Operation, ".difficulty_table" do
  it "returns an indexed hash of the expected values" do
    Operation::difficulty_table.should == { 0 => "Routine", 1 => "Moderate", 2 => "Severe" }
  end
end

describe Operation, "#to_s" do
  it "returns the procedure name followed by a formatted date" do
    procedure = mock_model(Procedure)
    procedure.stub(:to_s).and_return("Derp")
    operation = Operation.new(:date => "2010-08-12".to_date, :procedure => procedure)
    operation.to_s.should == "Derp - 2010-08-12"
  end
end

describe Operation, "#build_implant" do
  before(:each) do
    @operation = Operation.new
  end
  it "does not set implant if one already exists" do
    implant = mock_model(Implant)
    @operation.stub(:implant).and_return(implant)
    @operation.build_implant
    @operation.implant.should == implant
  end
  it "builds and sets a KneeImplant if Operation's body part is a knee" do
    @operation.stub(:body_part).and_return(mock_model(BodyPart, :name => "Knee"))
    @operation.build_implant
    @operation.implant.should be_a_kind_of(KneeImplant)
  end
  it "builds and sets a HipImplant if Operation's body part is a hip" do
    @operation.stub(:body_part).and_return(mock_model(BodyPart, :name => "Hip"))
    @operation.build_implant
    @operation.implant.should be_a_kind_of(HipImplant)
  end
  it "builds and sets an Implant if Operation's body part is not known" do
    @operation.build_implant
    @operation.implant.should be_a_kind_of(Implant)
  end
  it "implant operation is set to self" do
    @operation.build_implant
    @operation.implant.operation.should == @operation
  end
  it "implant body part is set to self's" do
    part = mock_model(BodyPart, :name => "Whatevs, yo.")
    @operation.stub(:body_part).and_return(part)
    @operation.build_implant
    @operation.implant.body_part.should == part
  end
end
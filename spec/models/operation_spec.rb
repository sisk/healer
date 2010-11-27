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
  should_have_column :schedule_order, :type => :integer

  should_belong_to :procedure
  should_belong_to :patient
  should_belong_to :diagnosis
  should_belong_to :body_part
  should_belong_to :primary_surgeon
  should_belong_to :secondary_surgeon
  should_belong_to :anesthesiologist
  should_belong_to :room
  should_belong_to :registration
  should_belong_to :trip

  should_have_one :implant
  should_have_one :knee_implant
  should_have_one :hip_implant

  should_have_many :xrays

  should_validate_presence_of :registration
  should_validate_presence_of :patient
  # should_validate_presence_of :body_part
  # should_validate_presence_of :date

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
  before(:each) do
    @operation = Operation.new(:patient => stub_model(Patient, :to_s => "El Hombre"), :trip => stub_model(Trip, :to_s => "The Place"))
  end
  it "returns the trip name plus patient name" do
    @operation.to_s.should == "The Place - El Hombre"
  end
  it "adds the procedure if it exists" do
    procedure = stub_model(Procedure, :to_s => "Derp")
    @operation.procedure = procedure
    @operation.to_s.should == "The Place - El Hombre - Derp"
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

describe Operation, "trip_id sync" do
  before(:each) do
    @operation = Operation.new(:registration => mock_model(Registration, :trip_id => 5))
    @operation.stub(:set_patient_id)
  end
  it "sets trip_id to the registration's id if not set" do
    lambda { @operation.valid? }.should change { @operation.trip_id }.from(nil).to(5)
  end
  it "sets trip_id to the registration's if they differ" do
    @operation.trip_id = 6
    lambda { @operation.valid? }.should change { @operation.trip_id }.from(6).to(5)
  end
  it "generally, leaves its trip_id alone" do
    @operation.trip_id = 5
    lambda { @operation.valid? }.should_not change { @operation.trip_id }
  end
end

describe Operation, "patient_id sync" do
  before(:each) do
    @operation = Operation.new(:registration => mock_model(Registration, :patient_id => 5))
    @operation.stub(:set_trip_id)
  end
  it "sets patient_id to the registration's id if not set" do
    lambda { @operation.valid? }.should change { @operation.patient_id }.from(nil).to(5)
  end
  it "sets patient_id to the registration's if they differ" do
    @operation.patient_id = 6
    lambda { @operation.valid? }.should change { @operation.patient_id }.from(6).to(5)
  end
  it "generally, leaves its patient_id alone" do
    @operation.patient_id = 5
    lambda { @operation.valid? }.should_not change { @operation.patient_id }
  end
end

describe Operation, ".order_schedule" do
  
end
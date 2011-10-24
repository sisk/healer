require 'spec_helper'

describe CaseGroup do
  should_have_column :schedule_order, :type => :integer
  should_have_column :room_number, :type => :integer
  should_have_column :scheduled_day, :type => :integer
  should_have_many :patient_cases
  should_belong_to :trip
end

describe CaseGroup, "#remove" do
  before(:each) do
    @case_group = CaseGroup.new
    @case_group.stub(:reload)
  end
  it "takes a case argument" do
    lambda { @case_group.remove }.should raise_error(ArgumentError)
  end
  it "clears the case_group_id from the case" do
    pc = mock_model(PatientCase)
    @case_group.stub(:patient_cases).and_return([pc])
    @case_group.patient_cases.should_receive(:delete).with(pc)
    @case_group.remove(pc)
  end
  it "preserves itself if patient cases remain" do
    @case_group.stub(:patient_cases).and_return([mock_model(PatientCase)])
    @case_group.should_not_receive(:destroy)
    @case_group.remove(mock_model(PatientCase))
  end
  it "destroys itself if no patint cases remain" do
    @case_group.stub(:patient_cases).and_return([])
    @case_group.should_receive(:destroy)
    @case_group.remove(mock_model(PatientCase))
  end
end

describe CaseGroup, ".remove_orphans" do
  it "issues a command to destroy orphaned records for a trip id" do
    CaseGroup.stub(:destroy_all)
    CaseGroup.should_receive(:destroy_all).with("trip_id = 2 AND id NOT IN (SELECT case_group_id FROM patient_cases where trip_id = 2)")
    CaseGroup.remove_orphans(2)
  end
end

describe CaseGroup, "#patient" do
  it "returns the patient from its first case" do
    p = mock_model(Patient)
    case_group = CaseGroup.new
    case_group.stub(:patient_cases).and_return([mock_model(PatientCase, :patient => p)])
    case_group.patient.should == p
  end
end

# describe CaseGroup, "schedule!" do
#   # TODO state machine approach might be better for this.
#   before(:each) do
#     @case_group = CaseGroup.new(:trip => mock_model(Trip))
#     @case_group.stub(:save)
#   end
#   it "sets the room" do
#     lambda { @case_group.schedule! }.should change { @case_group.room_number }
#   end
#   it "saves the object" do
#     @case_group.should_receive(:save)
#     @case_group.schedule!
#   end
# end

describe CaseGroup, "unschedule!" do
  # TODO state machine approach might be better for this.
  before(:each) do
    @case_group = CaseGroup.new(:trip => mock_model(Trip), :room_number => 1, :scheduled_day => 4)
    @case_group.stub(:save)
  end
  it "clears the room" do
    lambda { @case_group.unschedule! }.should change { @case_group.room_number }.to(nil)
  end
  it "sets scheduled day to zero" do
    lambda { @case_group.unschedule! }.should change { @case_group.scheduled_day }.to(0)
  end
  it "saves the object" do
    @case_group.should_receive(:save)
    @case_group.unschedule!
  end
end

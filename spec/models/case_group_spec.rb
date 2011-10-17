require 'spec_helper'

describe CaseGroup do
  should_have_column :schedule_order, :type => :integer
  should_have_column :room_id, :type => :integer
  should_have_column :scheduled_day, :type => :integer
  should_have_many :patient_cases
  should_belong_to :trip
  should_belong_to :room
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
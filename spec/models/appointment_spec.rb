require 'spec_helper'

describe Appointment do
  should_have_column :schedule_order, :type => :integer
  should_have_column :room_number, :type => :integer
  should_have_column :scheduled_day, :type => :integer
  should_have_many :patient_cases
  should_have_many :operations
  should_belong_to :trip
end

describe Appointment, "#remove" do
  before(:each) do
    @appointment = Appointment.new
    @appointment.stub(:reload)
  end
  it "takes a case argument" do
    lambda { @appointment.remove }.should raise_error(ArgumentError)
  end
  it "clears the appointment_id from the case" do
    pc = mock_model(PatientCase, :revision? => false)
    @appointment.stub(:patient_cases).and_return([pc])
    @appointment.patient_cases.should_receive(:delete).with(pc)
    @appointment.remove(pc)
  end
  it "preserves itself if patient cases remain" do
    @appointment.stub(:patient_cases).and_return([mock_model(PatientCase, :revision? => false)])
    @appointment.should_not_receive(:destroy)
    @appointment.remove(mock_model(PatientCase, :revision? => false))
  end
  it "destroys itself if no patint cases remain" do
    @appointment.stub(:patient_cases).and_return([])
    @appointment.should_receive(:destroy)
    @appointment.remove(mock_model(PatientCase, :revision? => false))
  end
end

describe Appointment, ".remove_orphans" do
  it "issues a command to destroy orphaned records for a trip id" do
    Appointment.stub(:destroy_all)
    Appointment.should_receive(:destroy_all).with("trip_id = 2 AND id NOT IN (SELECT appointment_id FROM patient_cases where trip_id = 2 and appointment_id is not null)")
    Appointment.remove_orphans(2)
  end
end

describe Appointment, "#patient" do
  it "returns the patient from its first case" do
    p = mock_model(Patient)
    appointment = Appointment.new
    appointment.stub(:patient_cases).and_return([mock_model(PatientCase, :revision? => false, :patient => p)])
    appointment.patient.should == p
  end
end

describe Appointment, "unschedule!" do
  # TODO state machine approach might be better for this.
  before(:each) do
    @appointment = Appointment.new(:trip => mock_model(Trip), :room_number => 1, :scheduled_day => 4)
    @appointment.stub(:save)
  end
  it "clears the room" do
    lambda { @appointment.unschedule! }.should change { @appointment.room_number }.to(nil)
  end
  it "sets scheduled day to zero" do
    lambda { @appointment.unschedule! }.should change { @appointment.scheduled_day }.to(0)
  end
  it "saves the object" do
    @appointment.should_receive(:save)
    @appointment.unschedule!
  end
end

describe Appointment, "#bilateral?" do

  before(:each) do
    @c1 = mock(PatientCase)
    @c2 = mock(PatientCase)
    @c3 = mock(PatientCase)
    @c1.stub(:bilateral_case).and_return(@c2)
    @c2.stub(:bilateral_case).and_return(@c1)
  end

  it "is true if any patient cases have a bilateral case" do
    cg = Appointment.new
    cg.stub(:patient_cases).and_return([@c1, @c2])
    cg.bilateral?.should be_true
  end

  it "is false if case number doesn't match" do
    cg = Appointment.new
    cg.stub(:patient_cases).and_return([@c1])
    cg.bilateral?.should be_false
  end

  it "is false if no patient cases have a bilateral case" do
    cg = Appointment.new
    cg.stub(:patient_cases).and_return([@c3])
    cg.bilateral?.should be_false
  end

end
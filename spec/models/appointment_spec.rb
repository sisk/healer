require 'spec_helper'

describe Appointment, "#remove" do
  before(:each) do
    @appointment = Appointment.new
    @appointment.stub(:reload)
  end
  it "takes a case argument" do
    lambda { @appointment.remove }.should raise_error(ArgumentError)
  end
  it "clears the appointment_id from the case" do
    pc = double(PatientCase, :revision? => false)
    @appointment.stub(:patient_cases).and_return([pc])
    @appointment.patient_cases.should_receive(:delete).with(pc)
    @appointment.remove(pc)
  end
  it "preserves itself if patient cases remain" do
    @appointment.stub(:patient_cases).and_return([double(PatientCase, :revision? => false)])
    @appointment.should_not_receive(:destroy)
    @appointment.remove(double(PatientCase, :revision? => false))
  end
  it "destroys itself if no patint cases remain" do
    @appointment.stub(:patient_cases).and_return([])
    @appointment.should_receive(:destroy)
    @appointment.remove(double(PatientCase, :revision? => false))
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
    p = double(Patient)
    appointment = Appointment.new
    appointment.stub(:patient_cases).and_return([double(PatientCase, :revision? => false, :patient => p)])
    appointment.patient.should == p
  end
end

describe Appointment, "unschedule!" do
  it "set the room number to nil" do
    appointment = Appointment.create!(:trip => create(:trip), :room_number => 1)

    appointment.room_number.should == 1

    appointment.unschedule!

    appointment.reload.room_number.should be_nil
  end
  it "sets scheduled day to zero" do
    appointment = Appointment.create!(:trip => create(:trip), :scheduled_day => 4)

    appointment.scheduled_day.should == 4

    appointment.unschedule!

    appointment.scheduled_day.should == 0
  end
end

describe Appointment, "#bilateral?" do

  before(:each) do
    @c1 = double(PatientCase)
    @c2 = double(PatientCase)
    @c3 = double(PatientCase)
    @c1.stub(:bilateral_case).and_return(@c2)
    @c2.stub(:bilateral_case).and_return(@c1)
  end

  it "is true if two patient cases are present on the same trip with opposite anatomies" do
    appointment = Appointment.new(:trip => create(:trip))
    appointment.patient_cases << create(:patient_case, :anatomy => "knee", :side => "left", :trip => appointment.trip)
    appointment.patient_cases << create(:patient_case, :anatomy => "knee", :side => "right", :trip => appointment.trip)

    appointment.bilateral?.should be_true
  end

  it "is false if two patient cases are present on different trips with opposite anatomies" do
    trip1 = create(:trip, :nickname => "trip1")
    trip2 = create(:trip, :nickname => "trip2")
    appointment = Appointment.new(:trip => trip1)
    appointment.patient_cases << create(:patient_case, :anatomy => "knee", :side => "left", :trip => trip1)
    appointment.patient_cases << create(:patient_case, :anatomy => "knee", :side => "right", :trip => trip2)

    appointment.bilateral?.should be_false
  end

  it "is false if no case is on the same trip as the appointment" do
    trip1 = create(:trip, :nickname => "trip1")
    trip2 = create(:trip, :nickname => "trip2")
    appointment = Appointment.new(:trip => trip1)
    appointment.patient_cases << create(:patient_case, :anatomy => "knee", :side => "left", :trip => trip2)
    appointment.patient_cases << create(:patient_case, :anatomy => "knee", :side => "right", :trip => trip2)

    appointment.bilateral?.should be_false
  end

  it "is false if only one patient case is present" do
    trip1 = create(:trip, :nickname => "trip1")
    appointment = Appointment.new(:trip => trip1)
    appointment.patient_cases << create(:patient_case, :anatomy => "knee", :side => "left", :trip => trip1)

    appointment.bilateral?.should be_false
  end

  it "is false if only one patient case is present" do
    trip1 = create(:trip, :nickname => "trip1")
    appointment = Appointment.new(:trip => trip1)
    appointment.patient_cases << create(:patient_case, :anatomy => "knee", :side => "left", :trip => trip1)

    appointment.bilateral?.should be_false
  end

end
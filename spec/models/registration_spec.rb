require 'spec_helper'

describe Registration do
  should_have_column :patient_id, :type => :integer
  should_have_column :approved_by_id, :type => :integer
  should_have_column :created_by_id, :type => :integer
  should_have_column :trip_id, :type => :integer
  should_have_column :approved_at, :type => :datetime
  should_have_column :notes, :type => :text
  should_have_column :checkin_at, :type => :datetime
  should_have_column :checkout_at, :type => :datetime
  should_have_column :status, :type => :string
  should_have_column :location, :type => :string
  should_have_column :schedule_order, :type => :integer
  should_have_column :room_id, :type => :integer

  should_belong_to :patient
  should_belong_to :trip
  should_belong_to :approved_by
  should_belong_to :created_by
  should_have_many :operations
  
  should_validate_presence_of :patient
  should_validate_presence_of :trip
  should_validate_inclusion_of :status, :in => Registration::possible_statuses, :allow_nil => true
end

describe Registration, "authorize!" do
  before(:each) do
    @registration = Registration.new
  end
  it "sets registration's approved_at to now" do
    time = Time.now
    Time.stub(:now).and_return(time)
    @registration.authorize!
    @registration.approved_at.should == time
  end
  it "sets approved_by_id to parameter if passed" do
    @registration.authorize!(3)
    @registration.approved_by_id.should == 3
  end
  it "clears approved_by_id if no parameter is passed" do
    @registration.authorize!
    @registration.approved_by_id.should be_nil
  end
  it "sets status to 'Registered'" do
    @registration.authorize!
    @registration.status.should == "Registered"
  end
end
describe Registration, "deauthorize!" do
  before(:each) do
    @registration = Registration.new(:approved_by_id => 1, :approved_at => Time.now)
  end
  it "sets registration's approved_at to nil" do
    @registration.deauthorize!
    @registration.approved_at.should be_nil
  end
  it "clears approved_by_id" do
    @registration.deauthorize!
    @registration.approved_by_id.should be_nil
  end
  it "sets status to 'Pre-Screen'" do
    @registration.deauthorize!
    @registration.status.should == "Pre-Screen"
  end
end

describe Registration, "authorized?" do
  before(:each) do
    @registration = Registration.new
  end
  it "returns true if approved_at is set" do
    @registration.approved_at = Time.now
    @registration.authorized?.should == true
  end
  it "returns false if approved_at is blank" do
    @registration.authorized?.should == false
  end
end

describe Registration, "to_s" do
  it "returns the trip's string value + patient's string value" do
    trip = mock_model(Trip)
    trip.stub(:to_s).and_return("Las Vegas 2008")
    patient = mock_model(Patient)
    patient.stub(:to_s).and_return("Elvis Presley")
    registration = Registration.new(:trip => trip, :patient => patient)
    registration.to_s.should == "Elvis Presley - Las Vegas 2008"
  end
end

describe Registration, ".possible_statuses" do
  # Pre-Screen -> Registered -> Checked In | Scheduled -> Preparation -> Procedure -> Recovery -> Discharge -> Checked Out
  it "returns an array of the expected values" do
    Registration::possible_statuses.should == ["Pre-Screen","Registered","Checked In","Scheduled","Unscheduled","Preparation","Procedure","Recovery","Discharge","Checked Out"]
  end
end

describe Registration, "in_facility?" do
  before(:each) do
    @registration = Registration.new
  end
  ["Checked In","Preparation","Procedure","Recovery","Discharge"].each do |status|
    it "is true if status is #{status}" do
      @registration.status = status
      @registration.in_facility?.should be_true
    end
  end
  (Registration::possible_statuses - ["Checked In","Preparation","Procedure","Recovery","Discharge"]).each do |status|
    it "is false if status is #{status}" do
      @registration.status = status
      @registration.in_facility?.should be_false
    end
  end
  it "is usually false" do
    @registration.in_facility?.should be_false
  end
end

describe Registration, "schedule" do
  # TODO state machine approach might be better for this.
  before(:each) do
    @registration = Registration.new
  end
  ["Registered","Unscheduled"].each do |status|
    it "changes status from #{status} to 'Scheduled'" do
      @registration.status = status
      lambda { @registration.schedule }.should change { @registration.status }.to('Scheduled')
    end
  end
  (Registration::possible_statuses - ["Registered","Unscheduled"]).each do |status|
    it "does not change the status when set to #{status}" do
      @registration.status = status
      lambda { @registration.schedule }.should_not change { @registration.status }
    end
  end
end

describe Registration, "unschedule" do
  # TODO state machine approach might be better for this.
  before(:each) do
    @registration = Registration.new
  end
  (Registration::possible_statuses - ["Unscheduled"]).each do |status|
    it "changes status from #{status} to 'Unscheduled'" do
      @registration.status = status
      lambda { @registration.unschedule }.should change { @registration.status }.to('Unscheduled')
    end
  end
end
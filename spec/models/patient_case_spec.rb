require 'spec_helper'

describe PatientCase do
  before(:each) do
    PatientCase.stub(:set_bilateral) # custom validation routine
  end
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
  should_have_column :likely_bilateral, :type => :boolean
  should_have_column :complexity, :type => :integer
  should_have_column :scheduled_day, :type => :integer

  should_belong_to :patient
  should_belong_to :trip
  should_belong_to :approved_by
  should_belong_to :created_by
  should_have_many :operations
  should_have_many :diagnoses
  should_have_many :physical_therapies
  
  should_validate_presence_of :patient
  should_validate_presence_of :trip
  should_validate_inclusion_of :status, :in => PatientCase::possible_statuses, :allow_nil => true
end

describe PatientCase, "authorize!" do
  before(:each) do
    @patient_case = PatientCase.new(:patient => stub_model(Patient), :trip => mock_model(Trip))
  end
  it "sets case's approved_at to now" do
    time = Time.now
    Time.stub(:now).and_return(time)
    @patient_case.authorize!
    @patient_case.approved_at.should == time
  end
  it "sets approved_by_id to parameter if passed" do
    @patient_case.authorize!(3)
    @patient_case.approved_by_id.should == 3
  end
  it "clears approved_by_id if no parameter is passed" do
    @patient_case.authorize!
    @patient_case.approved_by_id.should be_nil
  end
  it "sets status to 'Registered'" do
    @patient_case.authorize!
    @patient_case.status.should == "Registered"
  end
  # temp - this is a workaround until UI elements join diagnoses to a case.
  it "sets all untreated diagnoses for patient to this case" do
    diag1 = stub_model(Diagnosis)
    diag2 = stub_model(Diagnosis)
    @patient_case.patient.stub_chain(:diagnoses, :untreated).and_return([diag1, diag2])
    @patient_case.diagnoses = []
    @patient_case.authorize!
    @patient_case.diagnoses.should == [diag1,diag2]
  end
  it "returns true" do
    @patient_case.authorize!.should == true
  end
end

describe PatientCase, "deauthorize!" do
  before(:each) do
    @patient_case = PatientCase.new(:patient => stub_model(Patient), :trip => mock_model(Trip), :approved_by_id => 1, :approved_at => Time.now, :room_id => 2, :scheduled_day => 3)
  end
  it "sets case's approved_at to nil" do
    @patient_case.deauthorize!
    @patient_case.approved_at.should be_nil
  end
  it "clears approved_by_id" do
    @patient_case.deauthorize!
    @patient_case.approved_by_id.should be_nil
  end
  it "sets status to 'Pre-Screen'" do
    @patient_case.deauthorize!
    @patient_case.status.should == "Pre-Screen"
  end
  it "clears any room" do
    @patient_case.deauthorize!
    @patient_case.room_id.should be_nil
  end
  it "clears any day" do
    @patient_case.deauthorize!
    @patient_case.scheduled_day.should be_nil
  end
  # temp - this is a workaround until UI elements join diagnoses to a case.
  # it "clears diagnoses" do
  #   diag1 = stub_model(Diagnosis, :patient_case_id => @patient_case.id)
  #   @patient_case.diagnoses = [diag1]
  #   @patient_case.deauthorize!
  #   @patient_case.diagnoses.should == []
  #   diag1.patient_case_id.should be_nil
  # end
  it "returns true" do
    @patient_case.deauthorize!.should == true
  end
end

describe PatientCase, "authorized?" do
  before(:each) do
    @patient_case = PatientCase.new(:patient => stub_model(Patient), :trip => mock_model(Trip))
  end
  it "returns true if approved_at is set" do
    @patient_case.approved_at = Time.now
    @patient_case.authorized?.should == true
  end
  it "returns false if approved_at is blank" do
    @patient_case.authorized?.should == false
  end
end

describe PatientCase, "to_s" do
  it "returns the trip's string value + patient's string value" do
    trip = mock_model(Trip)
    trip.stub(:to_s).and_return("Las Vegas 2008")
    patient = mock_model(Patient)
    patient.stub(:to_s).and_return("Elvis Presley")
    patient_case = PatientCase.new(:trip => trip, :patient => patient)
    patient_case.to_s.should == "Elvis Presley - Las Vegas 2008"
  end
end

describe PatientCase, ".complexity_units" do
  it "returns an array of the expected values" do
    PatientCase::complexity_units.should == [1,2,3,4,5,6,7,8,9,10]
  end
end

describe PatientCase, ".possible_statuses" do
  # Pre-Screen -> Registered -> Checked In | Scheduled -> Preparation -> Procedure -> Recovery -> Discharge -> Checked Out
  it "returns an array of the expected values" do
    PatientCase::possible_statuses.should == ["Pre-Screen","Registered","Checked In","Scheduled","Unscheduled","Preparation","Procedure","Recovery","Discharge","Checked Out"]
  end
end

describe PatientCase, "in_facility?" do
  before(:each) do
    @patient_case = PatientCase.new(:patient => stub_model(Patient), :trip => mock_model(Trip))
  end
  ["Checked In","Preparation","Procedure","Recovery","Discharge"].each do |status|
    it "is true if status is #{status}" do
      @patient_case.status = status
      @patient_case.in_facility?.should be_true
    end
  end
  (PatientCase::possible_statuses - ["Checked In","Preparation","Procedure","Recovery","Discharge"]).each do |status|
    it "is false if status is #{status}" do
      @patient_case.status = status
      @patient_case.in_facility?.should be_false
    end
  end
  it "is usually false" do
    @patient_case.in_facility?.should be_false
  end
end

describe PatientCase, "schedule!" do
  # TODO state machine approach might be better for this.
  before(:each) do
    @patient_case = PatientCase.new(:patient => stub_model(Patient), :trip => mock_model(Trip))
    @patient_case.stub(:save)
  end
  ["Registered","Unscheduled"].each do |status|
    it "changes status from #{status} to 'Scheduled'" do
      @patient_case.status = status
      lambda { @patient_case.schedule! }.should change { @patient_case.status }.to('Scheduled')
    end
  end
  (PatientCase::possible_statuses - ["Registered","Unscheduled"]).each do |status|
    it "does not change the status when set to #{status}" do
      @patient_case.status = status
      lambda { @patient_case.schedule! }.should_not change { @patient_case.status }
    end
  end
  it "saves the object" do
    @patient_case.should_receive(:save)
    @patient_case.schedule!
  end
end

describe PatientCase, "unschedule!" do
  # TODO state machine approach might be better for this.
  before(:each) do
    @patient_case = PatientCase.new(:patient => stub_model(Patient), :trip => mock_model(Trip), :room_id => 1, :scheduled_day => 4)
    @patient_case.stub(:save)
  end
  (PatientCase::possible_statuses - ["Unscheduled"]).each do |status|
    it "changes status from #{status} to 'Unscheduled'" do
      @patient_case.status = status
      lambda { @patient_case.unschedule! }.should change { @patient_case.status }.to('Unscheduled')
    end
  end
  it "clears the room" do
    lambda { @patient_case.unschedule! }.should change { @patient_case.room_id }.to(nil)
  end
  it "sets scheduled day to zero" do
    lambda { @patient_case.unschedule! }.should change { @patient_case.scheduled_day }.to(0)
  end
  it "saves the object" do
    @patient_case.should_receive(:save)
    @patient_case.unschedule!
  end
end

describe PatientCase, "#bilateral_diagnosis?" do
  before(:each) do
    @patient_case = PatientCase.new
    @bilateral = stub_model(Diagnosis, :has_mirror? => true)
    @non_bilateral = stub_model(Diagnosis, :has_mirror? => false)
  end
  it "is false if no diagnoses exist" do
    @patient_case.diagnoses = []
    @patient_case.bilateral_diagnosis?.should be_false
  end
  it "is true if any of case's diagnoses are part of bilateral" do
    @patient_case.diagnoses = [stub_model(Diagnosis, :has_mirror? => true)]
    @patient_case.bilateral_diagnosis?.should be_true
  end
  it "is false if none of case's diagnoses are part of bilateral" do
    @patient_case.diagnoses = [stub_model(Diagnosis, :has_mirror? => false)]
    @patient_case.bilateral_diagnosis?.should be_false
  end
end

describe PatientCase, "#body_part_list" do
  before(:each) do
    @left_knee = stub_model(BodyPart, :to_s => "Knee (L)", :name_en => "Knee")
    @right_knee = stub_model(BodyPart, :to_s => "Knee (R)", :name_en => "Knee")
    @right_hip = stub_model(BodyPart, :to_s => "Hip (R)", :name_en => "Hip")
  end
  it "outputs a formatted date string of body parts for its diagnoses" do
    patient_case = PatientCase.new(:diagnoses => [
      stub_model(Diagnosis, :body_part => @left_knee),
      stub_model(Diagnosis, :body_part => @right_knee),
    ])
    patient_case.body_part_list.should == "Knee (L), Knee (R)"
  end
  it "outputs empty string if no diagnoses" do
    patient_case = PatientCase.new(:diagnoses => [])
    patient_case.body_part_list.should == ""
  end
  it "ignores nil body parts in diagnoses" do
    patient_case = PatientCase.new(:likely_bilateral => true, :diagnoses => [
      stub_model(Diagnosis, :body_part => @left_knee),
      stub_model(Diagnosis, :body_part => nil)
    ])
    patient_case.body_part_list.should == "Knee (L)"
  end
  it "outputs bilateral if case is likely bilateral and body parts are the same" do
    patient_case = PatientCase.new(:likely_bilateral => true, :diagnoses => [
      stub_model(Diagnosis, :body_part => @left_knee),
      stub_model(Diagnosis, :body_part => @right_knee),
    ])
    patient_case.body_part_list.should == "Knee (Bilateral)"
  end
  it "separates bilateral from non-bilateral parts" do
    patient_case = PatientCase.new(:likely_bilateral => true, :diagnoses => [
      stub_model(Diagnosis, :body_part => @left_knee),
      stub_model(Diagnosis, :body_part => @right_knee),
      stub_model(Diagnosis, :body_part => @right_hip),
    ])
    patient_case.body_part_list.should == "Knee (Bilateral), Hip (R)"
  end
end

describe PatientCase, "#time_in_words" do
  before(:each) do
    @patient_case = PatientCase.new
    @now = Time.now
    Time.stub(:now).and_return(@now)
  end
  it "returns text of complexity unit" do
    @patient_case.stub(:complexity_minutes).and_return(10)
    @patient_case.complexity = 3
    @patient_case.time_in_words.should == "30 minutes"
  end
  it "returns text of complexity unit (check 2)" do
    @patient_case.stub(:complexity_minutes).and_return(15)
    @patient_case.complexity = 6
    @patient_case.time_in_words.should == "1 hour, 30 minutes"
  end
  it "returns unknown if complexity is not set" do
    @patient_case.time_in_words.should == "Time Unknown"
  end
end

describe PatientCase, "revision?" do
  before(:each) do
    @patient_case = PatientCase.new
    @diag1 = stub_model(Diagnosis, :revision => true)
    @diag2 = stub_model(Diagnosis, :revision => false)
    @patient = stub_model(Patient)
    @patient.stub_chain(:diagnoses, :untreated).and_return([])
  end
  context "case has diagnoses itself" do
    before(:each) do
      @patient_case.stub(:patient).and_return(@patient)
    end
    it "is true if any diagnoses are revisions" do
      @patient_case.diagnoses = [@diag1]
      @patient_case.revision?.should be_true
    end
    it "is false if no diagnoses are revisions" do
      @patient_case.diagnoses = [@diag2]
      @patient_case.revision?.should be_false
    end
  end
  context "case has diagnoses only through the patient" do
    it "is true if any untreated patient diagnoses are revisions" do
      @patient.stub_chain(:diagnoses, :untreated).and_return([@diag1])
      @patient_case.stub(:patient).and_return(@patient)
      @patient_case.revision?.should be_true
    end
    it "is false if no untreated patient diagnoses are revisions" do
      @patient.stub_chain(:diagnoses, :untreated).and_return([@diag2])
      @patient_case.stub(:patient).and_return(@patient)
      @patient_case.revision?.should be_false
    end
  end
  context "case has no idea what diagnoses it has" do
    it "is false" do
      @patient_case.stub(:patient).and_return(@patient)
      @patient_case.revision?.should be_false
    end
  end
end

# describe PatientCase, "setting bilateral on save" do
#   before(:each) do
#     @patient_case = PatientCasecase.new(:patient => stub_model(Patient), :trip => mock_model(Trip))
#   end
#   it "sets likely_bilateral to false by default" do
#     @patient_case.save?
#     @patient_case.likely_bilateral.should be_false
#   end
#   it "sets likely_bilateral to true if patient has bilateral diagnoses" do
#     @patient_case.stub(:bilateral_diagnosis?).and_return(true)
#     @patient_case.save?
#     @patient_case.likely_bilateral.should be_true
#   end
#   it "sets likely_bilateral to false if patient does not have bilateral diagnoses" do
#     @patient_case.stub(:bilateral_diagnosis?).and_return(false)
#     @patient_case.valid?
#     @patient_case.likely_bilateral.should be_false
#   end
# end
require 'spec_helper'

describe PatientCase do
  should_have_column :patient_id, :type => :integer
  should_have_column :appointment_id, :type => :integer
  should_have_column :approved_by_id, :type => :integer
  should_have_column :created_by_id, :type => :integer
  should_have_column :trip_id, :type => :integer
  should_have_column :disease_id, :type => :integer
  should_have_column :approved_at, :type => :datetime
  should_have_column :notes, :type => :text
  should_have_column :status, :type => :string
  should_have_column :complexity, :type => :integer
  should_have_column :revision, :type => :boolean
  should_have_column :severity, :type => :integer

  should_belong_to :patient
  should_belong_to :appointment
  should_belong_to :trip
  should_belong_to :disease
  should_belong_to :body_part

  should_belong_to :approved_by
  should_belong_to :created_by
  should_have_one :operation
  should_have_many :physical_therapies
  should_have_many :xrays
  should_have_one :bilateral_case

  should_validate_presence_of :patient
  should_validate_presence_of :trip
  should_validate_inclusion_of :status, :in => PatientCase::possible_statuses, :allow_nil => true
end

describe PatientCase, "authorize!" do

  before(:all) do
    Appointment.stub(:join_bilateral_cases)
  end

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
  it "returns true" do
    @patient_case.authorize!.should == true
  end
end

describe PatientCase, "deauthorize!" do

  before(:all) do
    Appointment.stub(:join_bilateral_cases)
  end

  before(:each) do
    @patient_case = PatientCase.new(:patient => stub_model(Patient), :trip => mock_model(Trip), :approved_by_id => 1, :approved_at => Time.now)
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
  it "returns true" do
    @patient_case.deauthorize!.should == true
  end
end

describe PatientCase, "authorized?" do

  before(:all) do
    Appointment.stub(:join_bilateral_cases)
  end

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
  before(:all) do
    Appointment.stub(:join_bilateral_cases)
  end

  it "returns Case + ID" do
    patient_case = PatientCase.new
    patient_case.stub(:id).and_return(1)
    patient_case.stub(:body_part).and_return(nil)
    patient_case.to_s.should == "Case #1"
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

describe PatientCase, "#display_xray" do
  before(:each) do
    @operation = PatientCase.new
    @x1 = stub_model(Xray, :primary => nil, :photo_file_name => "1")
    @x2 = stub_model(Xray, :primary => false, :photo_file_name => "2")
    @x3 = stub_model(Xray, :primary => true, :photo_file_name => "3")
    @x4 = stub_model(Xray, :primary => true, :photo_file_name => "4")
  end
  it "returns nil if no xrays" do
    @operation.display_xray.should be_nil
  end
  it "returns the first xray if only one exists" do
    @operation.xrays = [@x1]
    @operation.display_xray.should == @x1
  end
  it "returns the first xray if any exist, but none are primary" do
    @operation.xrays = [@x1, @x2]
    @operation.display_xray.should == @x1
  end
  it "returns the only xray if it exists, but none are primary" do
    @operation.xrays = [@x2]
    @operation.display_xray.should == @x2
  end
  it "returns the first primary xray found" do
    # FIXME - breaking spec. dunno why.
    @operation.xrays = [@x1, @x2, @x3, @x4]
    @operation.display_xray.should == @x3
  end
end

describe PatientCase, "#display_xray" do
  before(:each) do
    @patient_case = PatientCase.new
    @x1 = stub_model(Xray, :primary => nil, :photo_file_name => "1")
    @x2 = stub_model(Xray, :primary => false, :photo_file_name => "2")
    @x3 = stub_model(Xray, :primary => true, :photo_file_name => "3")
    @x4 = stub_model(Xray, :primary => true, :photo_file_name => "4")
  end
  it "returns nil if no xrays" do
    @patient_case.display_xray.should be_nil
  end
  it "returns the first xray if only one exists" do
    @patient_case.xrays = [@x1]
    @patient_case.display_xray.should == @x1
  end
  it "returns the first xray if > 1 exist, but none are primary" do
    @patient_case.xrays = [@x1, @x2]
    @patient_case.display_xray.should == @x1
  end
  it "returns the first primary xray found" do
    @patient_case.xrays = [@x1, @x2, @x3, @x4]
    @patient_case.display_xray.should == @x3
  end
end

describe PatientCase, "#related_untreated_cases" do
  before(:each) do
    @c1 = mock_model(PatientCase, :operation => nil)
    @c2 = mock_model(PatientCase, :operation => mock_model(Operation))
    @c3 = mock_model(PatientCase, :operation => mock_model(Operation))
    @c4 = mock_model(PatientCase, :operation => nil)
    @patient_case = PatientCase.new(:patient => mock_model(Patient, :patient_cases => [@c1, @c2, @c3, @c4]))
    @patient_case.stub(:operation).and_return(nil)
  end
  it "contains all cases for this patient that don't already have an operation" do
    @patient_case.related_untreated_cases.should == [@c1,@c4]
  end
  it "does not contain itself" do
    @patient_case.related_untreated_cases.should_not include(@patient_case)
  end
  [@c2, @c3].each do |c|
    it "does not include treated cases" do
      @patient_case.related_untreated_cases.should_not include(c)
    end
  end
end

describe PatientCase, "treated?" do
  it "is true if operation is present" do
    patient_case = PatientCase.new
    patient_case.stub(:operation).and_return(mock_model(Operation))
    patient_case.treated?.should be_true
  end
  it "is false if operation is not present" do
    patient_case = PatientCase.new
    patient_case.treated?.should be_false
  end
end

describe PatientCase, "#set_appointment" do
  before(:each) do
    @patient_case = PatientCase.new
    PatientCase.stub(:find).and_return(@patient_case)
  end
  context "no appointment" do
    it ", when authorized, attaches itself to a new Appointment if one doesn't exist" do
      @patient_case.stub(:authorized?).and_return(true)
      lambda { @patient_case.send(:set_appointment) }.should change(@patient_case, :appointment_id)
    end
    it ", when unauthorized, does not alter the Appointment" do
      @patient_case.stub(:authorized?).and_return(false)
      lambda { @patient_case.send(:set_appointment) }.should_not change(@patient_case, :appointment_id)
    end
  end
  context "with appointment" do
    before(:each) do
      @patient_case = PatientCase.new
      PatientCase.stub(:find).and_return(@patient_case)
    end
    it ", when authorized, does not alter the Appointment" do
      @patient_case.appointment = stub_model(Appointment, :id => 3)
      @patient_case.stub(:authorized?).and_return(true)
      lambda { @patient_case.send(:set_appointment) }.should_not change(@patient_case, :appointment_id)
    end
    it ", when unauthorized, removes itself from the Appointment" do
      @patient_case.stub(:authorized?).and_return(false)
      @patient_case.appointment = stub_model(Appointment, :id => 3)
      @patient_case.appointment.should_receive(:remove).with(@patient_case)
      @patient_case.send(:set_appointment)
    end
    # it ", when unauthorized, clears the Appointment" do
    #   @patient_case.stub(:authorized?).and_return(false)
    #   @patient_case.appointment = stub_model(Appointment, :id => 3)
    #   lambda { @patient_case.send(:set_appointment) }.should change(@patient_case, :appointment_id).from(3).to(nil)
    # end
  end
end

describe PatientCase, ".group_cases" do

  before(:each) do
    @pc1 = PatientCase.new(:appointment => nil, :approved_at => Time.now, :trip_id => 1, :appointment_id => 1)
    @pc2 = PatientCase.new(:appointment => nil, :approved_at => Time.now, :trip_id => 1, :appointment_id => 2)
    @pc1.stub_chain(:appointment, :join_bilateral_cases)
  end

  # Error checking
  it "takes an array of PatientCases" do
    lambda { PatientCase.group_cases }.should raise_error(ArgumentError)
    lambda { PatientCase.group_cases(@pc1) }.should raise_error("Invalid cases.")
  end
  it "all elements must be PatientCase objects" do
    lambda { PatientCase.group_cases([@pc1,mock_model(User)]) }.should raise_error("Only cases may be grouped.")
  end
  it "all cases must be authorized" do
    @pc1.approved_at = nil
    lambda { PatientCase.group_cases([@pc1,@pc2]) }.should raise_error("All grouped cases must be authorized.")
  end
  it "all cases must belong to the same trip" do
    @pc1.trip_id = 2
    lambda { PatientCase.group_cases([@pc1,@pc2]) }.should raise_error("All grouped cases must belong to the same trip.")
  end

  it "ensures all cases have a group id" do
    PatientCase.group_cases([@pc1, @pc2])
    [@pc1, @pc2].all?{ |pc| pc.appointment_id.present? }.should be_true
  end

  it "uses the first appointment_id in the set" do
    PatientCase.group_cases([@pc1, @pc2])
    [@pc1, @pc2].map(&:appointment_id).uniq.compact.first.should == 1
  end

  it "ensures all cases' groups match" do
    PatientCase.group_cases([@pc1, @pc2])
    [@pc1, @pc2].map(&:appointment_id).uniq.compact.size.should == 1
  end

  it "creates a new Appointment when no case has a grouping" do
    @pc1.appointment_id = nil
    @pc2.appointment_id = nil
    Appointment.stub(:create)
    Appointment.should_receive(:create)
    PatientCase.group_cases([@pc1, @pc2])
  end

  it "uses the first valid non-nil appointment_id" do
    @pc1.appointment_id = nil
    PatientCase.group_cases([@pc1, @pc2])
    [@pc1, @pc2].map(&:appointment_id).uniq.compact.first.should == 2
  end

  it "clears the orphaned appointments" do
    Appointment.stub(:remove_orphans)
    Appointment.should_receive(:remove_orphans).with(1)
    PatientCase.group_cases([@pc1, @pc2])
  end

  it "joins the bilateral cases" do
    Appointment.stub(:remove_orphans)
    @pc1.appointment.should_receive(:join_bilateral_cases)
    PatientCase.group_cases([@pc1, @pc2])
  end

end

describe PatientCase, ".severity_table" do
  it "returns an indexed hash of the expected values" do
    PatientCase::severity_table.should == { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
end
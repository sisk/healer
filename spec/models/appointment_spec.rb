require 'spec_helper'

describe CaseGroup do
  should_have_column :schedule_order, :type => :integer
  should_have_column :room_number, :type => :integer
  should_have_column :scheduled_day, :type => :integer
  should_have_many :patient_cases
  should_have_many :operations
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
    pc = mock_model(PatientCase, :revision? => false)
    @case_group.stub(:patient_cases).and_return([pc])
    @case_group.patient_cases.should_receive(:delete).with(pc)
    @case_group.remove(pc)
  end
  it "preserves itself if patient cases remain" do
    @case_group.stub(:patient_cases).and_return([mock_model(PatientCase, :revision? => false)])
    @case_group.should_not_receive(:destroy)
    @case_group.remove(mock_model(PatientCase, :revision? => false))
  end
  it "destroys itself if no patint cases remain" do
    @case_group.stub(:patient_cases).and_return([])
    @case_group.should_receive(:destroy)
    @case_group.remove(mock_model(PatientCase, :revision? => false))
  end
end

describe CaseGroup, ".remove_orphans" do
  it "issues a command to destroy orphaned records for a trip id" do
    CaseGroup.stub(:destroy_all)
    CaseGroup.should_receive(:destroy_all).with("trip_id = 2 AND id NOT IN (SELECT case_group_id FROM patient_cases where trip_id = 2 and case_group_id is not null)")
    CaseGroup.remove_orphans(2)
  end
end

describe CaseGroup, "#patient" do
  it "returns the patient from its first case" do
    p = mock_model(Patient)
    case_group = CaseGroup.new
    case_group.stub(:patient_cases).and_return([mock_model(PatientCase, :revision? => false, :patient => p)])
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

describe CaseGroup, "#to_s" do

  before(:each) do
    @left_knee = mock(BodyPart, :display_name => "Knee", :side => "L", :to_s => "Knee (L)")
    @right_knee = mock(BodyPart, :display_name => "Knee", :side => "R", :to_s => "Knee (R)")
    @left_hip = mock(BodyPart, :display_name => "Hip", :side => "L", :to_s => "Hip (L)")
    @cg = CaseGroup.new
    @cg.stub(:bilateral?)
  end

  context "standard case" do
    before(:each) do
      @pc1 = mock(PatientCase, :body_part => @left_knee, :title => "Knee (L)", :revision? => false)
      @pc2 = mock(PatientCase, :body_part => @right_knee, :title => "Knee (R)", :revision? => false)
      @pc3 = mock(PatientCase, :body_part => @left_hip, :title => "Hip (L)", :revision? => false)
    end

    it "outputs single body part if only single case" do
      @cg.stub(:patient_cases).and_return([@pc1])
      @cg.to_s.should == "Knee (L)"
    end

    it "outputs comma-separated body parts if multiple cases" do
      @cg.stub(:patient_cases).and_return([@pc1, @pc3])
      @cg.to_s.should == "Knee (L), Hip (L)"
    end
  end

  context "bilateral case" do
    before(:each) do
      @pc4 = mock(PatientCase, :body_part => @left_knee, :bilateral_case => @pc5, :revision? => false, :title => "Knee (L)")
      @pc5 = mock(PatientCase, :body_part => @right_knee, :bilateral_case => @pc4, :revision? => false, :title => "Knee (R)")
    end

    it "outputs bilateral-notated name" do
      @cg.stub(:bilateral?).and_return(true)
      @cg.stub(:patient_cases).and_return([@pc4, @pc5])
      @cg.to_s.should == "Knee (Bilateral)"
    end

  end

  context "revisions" do
    it "outputs correct revision note if single case is revision" do
      @pc4 = mock(PatientCase, :body_part => @left_knee, :revision => true, :revision? => true, :title => "Revision Knee (L)")
      @cg.stub(:patient_cases).and_return([@pc4])
      @cg.to_s.should == "Revision Knee (L)"
    end

    it "outputs correct bilateral name if only one case is revision" do
      @pc4 = mock(PatientCase, :body_part => @left_knee, :bilateral_case => @pc5, :revision => true, :revision? => true, :title => "Revision Knee (L)")
      @pc5 = mock(PatientCase, :body_part => @right_knee, :bilateral_case => @pc4, :revision? => false, :title => "Knee (R)")
      @cg.stub(:bilateral?).and_return(true)
      @cg.stub(:patient_cases).and_return([@pc4, @pc5])
      @cg.to_s.should == "Revision Knee (L), Knee (R)"
    end

    it "outputs correct bilateral name if both cases are revision" do
      @pc4 = mock(PatientCase, :body_part => @left_knee, :bilateral_case => @pc5, :revision => true, :revision? => true, :title => "Revision Knee (L)")
      @pc5 = mock(PatientCase, :body_part => @right_knee, :bilateral_case => @pc4, :revision => true, :revision? => true, :title => "Revision Knee (R)")
      @cg.stub(:bilateral?).and_return(true)
      @cg.stub(:patient_cases).and_return([@pc4, @pc5])
      @cg.to_s.should == "Revision Knee (Bilateral)"
    end
  end

end

describe CaseGroup, "#bilateral?" do

  before(:each) do
    @c1 = mock(PatientCase)
    @c2 = mock(PatientCase)
    @c3 = mock(PatientCase)
    @c1.stub(:bilateral_case).and_return(@c2)
    @c2.stub(:bilateral_case).and_return(@c1)
  end

  it "is true if any patient cases have a bilateral case" do
    cg = CaseGroup.new
    cg.stub(:patient_cases).and_return([@c1, @c2])
    cg.bilateral?.should be_true
  end

  it "is false if case number doesn't match" do
    cg = CaseGroup.new
    cg.stub(:patient_cases).and_return([@c1])
    cg.bilateral?.should be_false
  end

  it "is false if no patient cases have a bilateral case" do
    cg = CaseGroup.new
    cg.stub(:patient_cases).and_return([@c3])
    cg.bilateral?.should be_false
  end

end
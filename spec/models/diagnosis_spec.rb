require 'spec_helper'

describe Diagnosis do
  should_have_column :patient_id, :type => :integer
  should_have_column :registration_id, :type => :integer
  should_have_column :body_part_id, :type => :integer
  should_have_column :disease_id, :type => :integer
  should_have_column :severity, :type => :integer, :default => 0
  should_have_column :assessed_date, :type => :date
  should_have_column :treated, :type => :boolean
  should_have_column :revision, :type => :boolean

  should_belong_to :patient
  should_belong_to :registration
  should_belong_to :disease
  should_belong_to :body_part
  should_have_many :operations
  should_have_many :xrays

  should_validate_presence_of :patient
  should_validate_presence_of :disease

  should_validate_numericality_of :severity
  should_validate_inclusion_of :severity, :in => Diagnosis::severity_table.keys

end

describe Diagnosis, "#to_s" do
  before(:each) do
    @disease = mock_model(Disease)
    @disease.stub(:to_s).and_return("Le Derp")
    @body_part = mock_model(BodyPart)
    @body_part.stub(:to_s).and_return("Shoulder Socket")
  end
  it "returns the disease" do
    Diagnosis.new(:disease => @disease).to_s.should == "Le Derp"
  end
  it "concatenates body part with a comma if that's set" do
    Diagnosis.new(:disease => @disease, :body_part => @body_part).to_s.should == "Le Derp, Shoulder Socket"
  end
end

describe Diagnosis, ".severity_table" do
  it "returns an indexed hash of the expected values" do
    Diagnosis::severity_table.should == { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
end

describe Diagnosis, "#siblings" do
  before(:each) do
    @diagnosis1 = Diagnosis.new
    @diagnosis1.stub(:id).and_return(1)
    @patient = stub_model(Patient)
    @diagnosis2 = Diagnosis.new
    @diagnosis2.stub(:id).and_return(2)
    @diagnosis3 = Diagnosis.new(:id => 3)
    @diagnosis3.stub(:id).and_return(3)
  end
  it "returns an array of all diagnoses for the patient excluding itself" do
    @patient.stub(:diagnoses).and_return([@diagnosis1,@diagnosis2,@diagnosis3])
    @diagnosis1.patient = @patient
    @diagnosis1.siblings.should == [@diagnosis2,@diagnosis3]
  end
  it "returns an empty array if no patient" do
    @diagnosis1.siblings.should == []
  end
  it "returns an empty array if patient has no diagnoses" do
    @patient.stub(:diagnoses).and_return([])
    @diagnosis1.patient = @patient
    @diagnosis1.siblings.should == []
  end
end

describe Diagnosis, "has_mirror?" do
  before(:each) do
    @patient = stub_model(Patient)
    @left_knee = stub_model(BodyPart,:name => "Knee", :side => "L")
    @right_knee = stub_model(BodyPart,:name => "Knee", :side => "R")
    @neck = stub_model(BodyPart,:name => "Neck")
    @neck.stub(:has_mirror?).and_return(false)
    @left_knee.stub(:mirror).and_return(@right_knee)
    @diagnosis = Diagnosis.new(:body_part => @left_knee, :patient => @patient)
    @diagnosis_r = Diagnosis.new(:body_part => @right_knee, :patient => @patient)
    @diagnosis_n = Diagnosis.new(:body_part => @neck, :patient => @patient)
  end
  it "is false if no body part is set" do
    Diagnosis.new.has_mirror?.should be_false
  end
  it "is false if body part has no mirror" do
    @diagnosis = Diagnosis.new(:body_part => @neck, :patient => @patient)
    @diagnosis.has_mirror?.should be_false
  end
  it "is false if no siblings" do
    @diagnosis.stub(:siblings).and_return([])
    @diagnosis.has_mirror?.should be_false
  end
  it "is false if sibling diagnoses have no body part matching this one's mirror" do
    @diagnosis.stub(:siblings).and_return([@diagnosis_n])
    @diagnosis.has_mirror?.should be_false
  end
  it "is true if sibling diagnoses have a body part matching this one's mirror" do
    @diagnosis.stub(:siblings).and_return([@diagnosis_r])
    @diagnosis.has_mirror?.should be_true
  end
end
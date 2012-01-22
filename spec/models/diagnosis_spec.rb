require 'spec_helper'

describe Diagnosis do
  should_have_column :patient_case_id, :type => :integer
  should_have_column :body_part_id, :type => :integer
  should_have_column :disease_id, :type => :integer
  should_have_column :severity, :type => :integer, :default => 0
  should_have_column :assessed_date, :type => :date
  should_have_column :treated, :type => :boolean
  should_have_column :revision, :type => :boolean

  # should_belong_to :patient_case
  should_belong_to :disease
  should_belong_to :body_part
  should_have_many :xrays

  # should_validate_presence_of :patient_case
  should_validate_presence_of :body_part

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
    @patient = stub_model(Patient)
    @diagnosis1 = Diagnosis.new
    @diagnosis2 = Diagnosis.new
    @patient.stub(:diagnoses).and_return([@diagnosis1, @diagnosis2])
    @diagnosis1.stub(:patient).and_return(@patient)
  end
  it "returns an array of all diagnoses for the patient excluding itself" do
    @diagnosis1.siblings.should == [@diagnosis2]
  end
  it "returns an empty array if no patient" do
    @diagnosis1.stub(:patient).and_return(nil)
    @diagnosis1.siblings.should == []
  end
end
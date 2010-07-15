require 'spec_helper'

describe Patient do
  it { should have_db_column(:name_first).of_type(:string) }
  it { should have_db_column(:name_last).of_type(:string) }
  it { should have_db_column(:name_middle).of_type(:string) }
  it { should have_db_column(:male).of_type(:boolean) }
  it { should have_db_column(:birth).of_type(:date) }
  it { should have_db_column(:death).of_type(:date) }
  it { should have_db_column(:address1).of_type(:string) }
  it { should have_db_column(:address2).of_type(:string) }
  it { should have_db_column(:city).of_type(:string) }
  it { should have_db_column(:state).of_type(:string) }
  it { should have_db_column(:zip).of_type(:string) }
  it { should have_db_column(:country).of_type(:string) }
  it { should have_db_column(:phone).of_type(:string) }
  it { should have_db_column(:height_cm).of_type(:decimal) }
  it { should have_db_column(:weight_kg).of_type(:decimal) }

  it { should validate_presence_of(:name_first) }
  it { should validate_presence_of(:name_last) }
  it "is invalid if male is nil" do
    @patient = Patient.new(:male => nil)
    @patient.should_not be_valid
  end

  it { should have_many(:patient_interactions) }
end

describe Patient, "#name" do
  before(:each) do
    @patient = Patient.new
  end
  it "returns First Last if no arguments are passed" do
    @patient.name_first = "First"
    @patient.name_last = "Last"
    @patient.name.should == "First Last"
  end
  it "returns Last, First if :last_first is an argument" do
    @patient.name_first = "First"
    @patient.name_last = "Last"
    @patient.name(:last_first).should == "Last, First"
  end
end

describe Patient, "#to_s" do
  before(:each) do
    @patient = Patient.new
  end
  describe "#to_s" do
    it "returns the value of name with no arguments" do
      @patient.stub(:name).and_return("Derp")
      @patient.to_s.should == "Derp"
    end
    it "returns the value of name with arguments" do
      @patient.stub(:name)
      @patient.stub(:name).with(:last_first).and_return("Derp")
      @patient.to_s(:last_first).should == "Derp"
    end
  end
end

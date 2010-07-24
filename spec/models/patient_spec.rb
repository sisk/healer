require 'spec_helper'

describe Patient do
  should_have_column :name_first, :type => :string
  should_have_column :name_last, :type => :string
  should_have_column :name_middle, :type => :string
  should_have_column :male, :type => :boolean
  should_have_column :birth, :type => :date
  should_have_column :death, :type => :date
  should_have_column :address1, :type => :string
  should_have_column :address2, :type => :string
  should_have_column :city, :type => :string
  should_have_column :state, :type => :string
  should_have_column :zip, :type => :string
  should_have_column :country, :type => :string
  should_have_column :phone, :type => :string
  should_have_column :height_cm, :type => :decimal
  should_have_column :weight_kg, :type => :decimal
  should_have_column :email, :type => :string

  should_validate_presence_of :name_first
  should_validate_presence_of :name_last

  it "is invalid if male is nil" do
    @patient = Patient.new(:male => nil)
    @patient.should_not be_valid
  end

  should_have_many :patient_interactions
  should_have_many :diagnoses

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

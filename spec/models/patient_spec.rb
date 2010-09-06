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
  should_have_many :operations
  should_have_many :registrations
  should_have_many :risk_factors

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

describe Patient, "#short_name" do
  it "returns first name if set" do
    Patient.new(:name_first => "Derp").short_name.should == "Derp"
  end
  it "returns middle name if first is not set" do
    Patient.new(:name_middle => "Derp").short_name.should == "Derp"
  end
  it "returns last name if neither first nor middle is set" do
    Patient.new(:name_last => "Derp").short_name.should == "Derp"
  end
end

describe Patient, "one_line_address" do
  before(:each) do
    @patient = Patient.new
  end
  it "returns concatenated address elements if any are set" do
    @patient.address1 = "A"
    @patient.address2 = "B"
    @patient.city = "C"
    @patient.state = "D"
    @patient.zip = "E"
    @patient.country = "F"
    @patient.one_line_address.should == "A, B, C, D, E, F"
  end
  it "returns nil if no address elements are set" do
    @patient.one_line_address.should == nil
  end
end

describe Patient, "registered?" do
  before(:each) do
    @patient = Patient.new(:registrations => [])
  end
  it "returns true if patient has any registrations" do
    @patient.registrations << stub_model(Registration)
    @patient.registered?.should == true
  end
  it "returns false if patient has no registrations" do
    @patient.registered?.should == false
  end
end

describe Patient, "has_contact?" do
  before(:each) do
    @patient = Patient.new
  end
  it "returns false by default" do
    @patient.has_contact?.should == false
  end
  %w(address1 address2 city state zip country phone email).each do |contact_field|
    it "returns true if #{contact_field} has a value" do
      @patient.stub_chain(contact_field, :present?).and_return(true)
      @patient.has_contact?.should == true
    end
  end
end

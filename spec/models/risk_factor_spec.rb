require 'spec_helper'

describe RiskFactor do
  should_have_column :patient_id, :type => :integer
  should_have_column :risk_id, :type => :integer
  should_have_column :severity, :type => :integer, :default => 0

  should_validate_presence_of :patient
  should_validate_presence_of :risk

  should_belong_to :patient
  should_belong_to :risk

  should_validate_numericality_of :severity
  should_validate_inclusion_of :severity, :in => RiskFactor::severity_table.keys
end

describe RiskFactor, "#to_s" do
  before(:each) do
    @risk = mock_model(Risk)
    @risk.stub(:to_s).and_return("Hypertension")
  end
  it "returns risk name alone if severity is nil" do
    RiskFactor.new(:risk => @risk, :severity => nil).to_s.should == "Hypertension"
  end
  it "returns risk name with severity string" do
    RiskFactor.new(:risk => @risk, :severity => 0).to_s.should == "Hypertension (Unremarkable)"
  end
end

describe RiskFactor, ".severity_table" do
  it "returns an indexed hash of the expected values" do
    RiskFactor::severity_table.should == { 0 => "Unremarkable", 1 => "Mild", 2 => "Moderate", 3 => "Severe" }
  end
end
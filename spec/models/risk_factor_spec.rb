require 'spec_helper'

describe RiskFactor do
  should_have_column :patient_id, :type => :integer
  should_have_column :risk_id, :type => :integer
  should_have_column :severe, :type => :boolean

  should_validate_presence_of :patient
  should_validate_presence_of :risk

  should_belong_to :patient
  should_belong_to :risk
end

describe RiskFactor, "#to_s" do
  before(:each) do
    @risk = mock_model(Risk)
    @risk.stub(:to_s).and_return("Hypertension")
  end
  it "returns risk name alone if not severe" do
    RiskFactor.new(:risk => @risk).to_s.should == "Hypertension"
  end
  it "returns risk name with (severe) if severe" do
    RiskFactor.new(:severe => true, :risk => @risk).to_s.should == "Hypertension (severe)"
  end
end
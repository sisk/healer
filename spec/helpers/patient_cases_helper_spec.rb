require 'spec_helper'

describe PatientCasesHelper, "#severity" do
  it "returns the proper corresponding value from severity_table" do
    PatientCase.stub(:severity_table).and_return({ 0 => "Derp" })
    @case = PatientCase.new(:severity => 0)
    helper.severity(@case).should == "Derp"
  end
end
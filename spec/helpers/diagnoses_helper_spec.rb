require 'spec_helper'

describe DiagnosesHelper, "#date_assessed" do
  it "outputs a formatted date string if date is known" do
    @diagnosis = Diagnosis.new(:assessed_date => "2010-06-07".to_date)
    helper.date_assessed(@diagnosis).should == "2010-06-07"
  end
  it "outputs unknown string if date is not known" do
    @diagnosis = Diagnosis.new(:assessed_date => nil)
    helper.date_assessed(@diagnosis).should == "Unknown"
  end
end

describe DiagnosesHelper, "#severity" do
  it "returns the proper corresponding value from severity_table" do
    Diagnosis.stub(:severity_table).and_return({ 0 => "Derp" })
    @diagnosis = Diagnosis.new(:severity => 0)
    helper.severity(@diagnosis).should == "Derp"
  end
end

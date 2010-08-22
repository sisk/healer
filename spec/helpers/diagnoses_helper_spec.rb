require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the DiagnosesHelper. For example:
#
# describe DiagnosesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe DiagnosesHelper, "#date_assessed" do
  it "outputs a formatted date string if date is known" do
    @diagnosis = Diagnosis.new(:assessed_date => "2010-06-07".to_date)
    helper.date_assessed(@diagnosis).should == "assessed 2010-06-07"
  end
  it "outputs unknown string if date is not known" do
    @diagnosis = Diagnosis.new(:assessed_date => nil)
    helper.date_assessed(@diagnosis).should == "unknown assessment date"
  end
end

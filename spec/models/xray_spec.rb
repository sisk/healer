require 'spec_helper'

describe Xray, "#to_s" do
  before(:each) do
    @xray = Xray.new
    @xray.stub_chain(:patient_case, :to_s).and_return("Derp")
  end
  it "returns expected string if date_time is not set" do
    @xray.to_s.should == "X-ray: Derp"
  end
  it "returns expected string if date_time is set" do
    the_time = "2010-07-10 5:00pm".to_time
    @xray.date_time = the_time
    @xray.to_s.should == "X-ray: Derp - #{the_time.to_s}"
  end
end
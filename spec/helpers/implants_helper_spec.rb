require 'spec_helper'

describe ImplantsHelper, "#output_type" do
  it "returns the underscored version of its class if it can be determined" do
    @implant = KneeImplant.new
    helper.output_type(@implant).should == "knee_implant"
  end
  it "returns 'unspecified' if a proper string can't be found" do
    @implant = Implant.new
    helper.output_type(@implant).should == "unspecified"
  end
end
require 'spec_helper'

describe Implant, ".desired_attributes" do
  it "returns an empty array" do
    Implant::desired_attributes.should == []
  end
end

describe Implant, "#attributes_complete?" do
  before(:each) do
    @implant = Implant.new
  end
  it "is false if any desired attributes are absent" do
    @implant.stub(:desired_attributes).and_return([:derp])
    @implant.stub(:derp).and_return(nil)
    @implant.attributes_complete?.should be_false
  end
  it "is true if all desired attributes are present" do
    @implant.stub(:desired_attributes).and_return([:derp])
    @implant.stub(:derp).and_return("derrrp!")
    @implant.attributes_complete?.should be_true
  end
end
require 'spec_helper'

describe Symptom, "#to_s" do
  before(:each) do
    @symptom = Symptom.new(:description => "Derp")
  end
  describe "#to_s" do
    it "returns the value of description" do
      @symptom.to_s.should == "Derp"
    end
  end
end


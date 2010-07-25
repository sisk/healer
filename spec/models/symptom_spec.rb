require 'spec_helper'

describe Symptom do
  should_have_column :description, :type => :string
  should_validate_presence_of :description
end

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


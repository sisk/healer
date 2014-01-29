require 'spec_helper'

describe Risk, "#to_s" do
  it "returns name" do
    Risk.new(:name => "Steroids").to_s.should == "Steroids"
  end
end
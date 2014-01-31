require 'spec_helper'

describe Room, "#to_s" do
  it "returns the title" do
    Room.new(:title => "Derp").to_s.should == "Derp"
  end
end

require 'spec_helper'

describe Facility, "#to_s" do
  it "returns the name" do
    Facility.new(:name => "Military Hospital").to_s.should == "Military Hospital"
  end
  it "appends the city if it exists" do
    Facility.new(:name => "Military Hospital", :city => "Guatemala City").to_s.should == "Military Hospital - Guatemala City"
  end
end

describe Facility, "one_line_address" do
  before(:each) do
    @facility = Facility.new
  end
  it "returns concatenated address elements if any are set" do
    @facility.address1 = "A"
    @facility.address2 = "B"
    @facility.city = "C"
    @facility.state = "D"
    @facility.zip = "E"
    @facility.country = "F"
    @facility.one_line_address.should == "A, B, C, D, E, F"
  end
  it "returns nil if no address elements are set" do
    @facility.one_line_address.should == nil
  end
end

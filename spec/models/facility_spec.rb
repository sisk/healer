require 'spec_helper'

describe Facility do
  should_have_column :name, :type => :string
  should_have_column :address1, :type => :string
  should_have_column :address2, :type => :string
  should_have_column :city, :type => :string
  should_have_column :state, :type => :string
  should_have_column :zip, :type => :string
  should_have_column :country, :type => :string

  should_validate_presence_of :name

  should_have_many :rooms
end

describe Facility, "#to_s" do
  it "returns the name" do
    Facility.new(:name => "Military Hospital").to_s.should == "Military Hospital"
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

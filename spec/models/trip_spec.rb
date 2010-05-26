require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Trip do
  it_has_the_attribute :start, :type => :date
  it_has_the_attribute :end, :type => :date
  it_has_the_attribute :country, :type => :string
  it_has_the_attribute :city, :type => :string
  it{should validate_presence_of(:country)}
end

describe Trip do
  before(:each) do
    @trip = Trip.new(:start => Date.parse("1/5/2009"))
    @trip = Trip.new(:start => nil)
    @trip.stub!(:country_name).and_return("Russia")
  end
  describe "#to_s" do
    context "when start date is not set" do
      it "returns the country" do
        @trip.to_s.should == "Russia"
      end
    end
    context "when start date is set" do
      before(:each) do
        @trip.start = Date.parse("1/5/2009")
      end
      it "returns the year and country" do
        @trip.to_s.should == "2009 Russia"
      end
    end
  end
end

# == Schema Information
#
# Table name: trips
#
#  id         :integer(4)      not null, primary key
#  start      :date
#  end        :date
#  country    :string(255)     not null
#  city       :string(255)
#  created_at :datetime
#  updated_at :datetime
#


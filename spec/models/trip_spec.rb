require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Trip do
  should_have_column :start, :type => :date
  should_have_column :end, :type => :date
  should_have_column :country, :type => :string
  should_have_column :city, :type => :string
  should_validate_presence_of :country
  should_have_and_belong_to_many :staff
  should_have_many :registrations
end

describe Trip, "#to_s" do
  before(:each) do
    # @trip = Trip.new(:start => Date.parse("1/5/2009"))
    @trip = Trip.new(:start => nil)
    @trip.stub!(:country_name).and_return("Russia")
  end
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

describe Trip, "#destination" do
  before(:each) do
    @trip = Trip.new
    @trip.stub!(:country_name).and_return("Russia")
  end
  context "when city is not set" do
    it "returns the country" do
      @trip.destination.should == "Russia"
    end
  end
  context "when city is set" do
    before(:each) do
      @trip.city = "Moscow"
    end
    it "returns the city and country concatenated with a comma" do
      @trip.destination.should == "Moscow, Russia"
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


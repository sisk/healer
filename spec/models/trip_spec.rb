require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Trip do
  should_have_column :start_date, :type => :date
  should_have_column :end_date, :type => :date
  should_have_column :procedure_start_date, :type => :date
  should_have_column :country, :type => :string
  should_have_column :city, :type => :string
  should_have_column :facility_id, :type => :integer
  should_have_column :complexity_minutes, :type => :integer
  should_have_column :daily_hours, :type => :integer
  should_have_column :available_rooms, :type => :integer
  should_have_column :number_of_operation_days, :type => :integer
  should_have_column :nickname, :type => :string
  should_validate_presence_of :country
  should_validate_presence_of :nickname
  should_validate_presence_of :start_date
  # should_have_and_belong_to_many :staff
  should_belong_to :facility
  should_have_many :patient_cases
  should_have_many :case_groups
  should_have_many :patients, :through => :patient_cases
  should_have_many :authorized_patients, :through => :patient_cases
  should_have_and_belong_to_many :users
end

describe Trip, "#to_s" do
  before(:each) do
    # @trip = Trip.new(:start_date => Date.parse("1/5/2009"))
    @trip = Trip.new(:start_date => nil)
    @trip.stub!(:country_name).and_return("Russia")
  end
  context "when start date is not set" do
    it "returns the country" do
      @trip.to_s.should == "Russia"
    end
  end
  context "when start date is set" do
    before(:each) do
      @trip.start_date = Date.parse("1/5/2009")
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

describe Trip, "#daily_complexity_units" do
  it "returns the correct product of complexity minutes and daily hours" do
    Trip.new(:complexity_minutes => 30, :daily_hours => 8).daily_complexity_units.should == 16
    Trip.new(:complexity_minutes => 15, :daily_hours => 1).daily_complexity_units.should == 4
  end
  it "is zero if complexity_minutes is blank" do
    Trip.new(:complexity_minutes => nil, :daily_hours => 8).daily_complexity_units.should == 0
  end
  it "is zero if daily_hours is blank" do
    Trip.new(:complexity_minutes => 30, :daily_hours => nil).daily_complexity_units.should == 0
  end
end

describe Trip, "#status" do
  before(:each) do
    @trip = Trip.new
    @jasons_birthday = "1975-05-28".to_date
    Date.stub(:today).and_return(@jasons_birthday)
  end
  it "returns 'unknown' by default" do
    @trip.status.should == "unknown"
  end
  context "start date has not occurred" do
    before(:each) do
      @trip.start_date = @jasons_birthday + 30.months
      @trip.end_date = nil
    end
    it "returns 'planning'" do
      @trip.status.should == "planning"
    end
    it "returns 'scheduling' if start date is within a 2 month window" do
      @trip.start_date = @jasons_birthday + 2.months
      @trip.status.should == "scheduling"
    end
  end
  context "start date has occurred" do
    before(:each) do
      @trip.start_date = @jasons_birthday - 3.days
    end
    it "returns 'preparing' by default" do
      @trip.status.should == "preparing"
    end
    it "returns 'active' if procedure_start_date has occurred, and number of operation days have not been reached" do
      @trip.procedure_start_date = @jasons_birthday - 1.day
      @trip.number_of_operation_days = 5
      @trip.status.should == "active"
    end
    it "returns 'cooldown' if procedure_start_date has occurred, and number of operation days have been reached" do
      @trip.procedure_start_date = @jasons_birthday - 6.days
      @trip.number_of_operation_days = 5
      @trip.status.should == "cooldown"
    end
  end
  it "returns 'complete' if end date has occurred" do
    @trip.start_date = @jasons_birthday - 10.days
    @trip.end_date = @jasons_birthday
    Date.stub(:today).and_return(@jasons_birthday + 1.day)
    @trip.status.should == "complete"
  end
end

describe Trip, "#current_day" do
  before(:each) do
    @trip = Trip.new
  end
  it "returns nil" do
    @trip.current_day.should be_nil
  end
  it "returns the right day if active" do
    @trip.stub(:status).and_return("active")
    @trip.start_date = "1975-05-01".to_date
    @trip.procedure_start_date = "1975-05-03".to_date
    @trip.number_of_operation_days = 3
    Date.stub(:today).and_return("1975-05-05".to_date)
    @trip.current_day.should == 3
  end
end

describe Trip, "nickname" do
  before(:each) do
    Carmen.stub(:country_name).with("GT").and_return("Guatemala")
  end
  it "sets itself on save if doesn't exist" do
    trip1 = Trip.new(:country => "GT", :start_date => "2011-02-23")
    lambda { trip1.save }.should change(trip1, :nickname).from(nil).to("guatemala2011")
    trip2 = Trip.new(:country => "GT", :start_date => nil)
    lambda { trip2.save }.should change(trip2, :nickname).from(nil).to("guatemala")
  end
  it "leaves nickname alone if already present" do
    trip = Trip.new(:country => "GT", :start_date => "2011-02-23", :nickname => "already here")
    lambda { trip.save }.should_not change(trip, :nickname)
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


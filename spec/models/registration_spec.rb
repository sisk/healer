require 'spec_helper'

describe Registration do
  should_have_column :patient_id, :type => :integer
  should_have_column :approved_by_id, :type => :integer
  should_have_column :created_by_id, :type => :integer
  should_have_column :trip_id, :type => :integer
  should_have_column :approved_at, :type => :datetime
  should_have_column :notes, :type => :text

  should_belong_to :patient
  should_belong_to :trip
  should_belong_to :approved_by
  should_belong_to :created_by
  
  should_validate_presence_of :patient
  should_validate_presence_of :trip
end

describe Registration, "authorize!" do
  before(:each) do
    @registration = Registration.new
  end
  it "sets registration's approved_at to now" do
    time = Time.now
    Time.stub(:now).and_return(time)
    @registration.authorize!
    @registration.approved_at.should == time
  end
  it "sets approved_by_id to parameter if passed" do
    @registration.authorize!(3)
    @registration.approved_by_id.should == 3
  end
  it "clears approved_by_id if no parameter is passed" do
    @registration.authorize!
    @registration.approved_by_id.should be_nil
  end
end
describe Registration, "deauthorize!" do
  before(:each) do
    @registration = Registration.new(:approved_by_id => 1, :approved_at => Time.now)
  end
  it "sets registration's approved_at to nil" do
    @registration.deauthorize!
    @registration.approved_at.should be_nil
  end
  it "clears approved_by_id" do
    @registration.deauthorize!
    @registration.approved_by_id.should be_nil
  end
end

describe Registration, "authorized?" do
  before(:each) do
    @registration = Registration.new
  end
  it "returns true if approved_at is set" do
    @registration.approved_at = Time.now
    @registration.authorized?.should == true
  end
  it "returns false if approved_at is blank" do
    @registration.authorized?.should == false
  end
end

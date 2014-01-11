require "spec_helper"
require "v1/trip_decorator"

describe V1::TripDecorator do

  describe "#name" do
    it "concatenates full name of year with country" do
      trip = build(:trip, :country => "PE", :start_date => Date.parse("1975-05-28"))
      decorator = V1::TripDecorator.new(trip)

      decorator.name.should == "1975 Peru"
    end

    it "omits year if no start date" do
      trip = build(:trip, :country => "AR", :start_date => nil)
      decorator = V1::TripDecorator.new(trip)

      decorator.name.should == "Argentina"
    end
  end

  describe "#country" do
    it "returns a full country name given an ISO code" do
      # implementation uses Carmen
      {
        "GT" => "Guatemala",
        "NI" => "Nicaragua"
      }.each do |iso, name|
        decorator = V1::TripDecorator.new(build(:trip, :country => iso))

        decorator.country.should == name
      end
    end
  end

  describe "#destination" do
    it "returns a city and country if both present on model" do
      trip = build(:trip, :country => "NI", :city => "Managua")
      decorator = V1::TripDecorator.new(trip)

      decorator.destination.should == "Managua, Nicaragua"
    end

    it "returns only country if no city present on model" do
      trip = build(:trip, :country => "NI", :city => nil)
      decorator = V1::TripDecorator.new(trip)

      decorator.destination.should == "Nicaragua"
    end
  end

  describe "#link" do
    it "returns the internal URL for the trip" do
      trip = create(:trip, :nickname => "derp")
      decorator = V1::TripDecorator.new(trip)

      decorator.link.should == "/v1/trips/derp"
    end
  end

  describe "#edit_link" do
    it "returns the internal edit URL for the trip" do
      trip = create(:trip, :nickname => "derp")
      decorator = V1::TripDecorator.new(trip)

      decorator.edit_link.should == "/v1/trips/derp/edit"
    end
  end

  describe "#nickname" do
    it "delegates to Trip model" do
      trip = build(:trip, :nickname => "derpy")

      decorator = V1::TripDecorator.new(trip)

      decorator.nickname.should == "derpy"
    end
  end

end
require "spec_helper"
require "v1/trips_controller"

describe V1::TripsController, :type => :controller do

  before(:each) do
    stub_user
  end

  describe "#index" do
    it "uses the v1 layout" do
      get :index

      expect(response).to render_template("v1")
    end

    it "assigns decorated @trips, ordered by start_date descending" do
      trip2 = create(:trip, :start_date => Date.today - 1.week, :nickname => "lastweek")
      trip1 = create(:trip, :start_date => Date.today - 1.day, :nickname => "yesterday")

      get :index

      expect(assigns(:trips)).to eq(V1::TripDecorator.decorate_collection([trip1, trip2]))
    end
  end

end
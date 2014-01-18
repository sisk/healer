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
  end

end
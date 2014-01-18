require "spec_helper"
require "v1/cases_controller"

describe V1::CasesController, :type => :controller do

  before(:each) do
    stub_user
  end

  describe "#new" do
    it "uses the v1 layout" do
      get :new

      expect(response).to render_template("v1")
    end
  end
end

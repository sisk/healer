require 'spec_helper'

# def do_action(request_method, action, params = {})
#   do_valid_login
#   send request_method, action, params
# end

describe PatientCasesController, "PUT authorize" do
  login_admin
  
  # before(:each) do
  #   @patient_case = mock_model(PatientCase)
  #   PatientCase.stub(:find_by_id).with(2).and_return(@patient_case)
  #   @params = { :trip_id => 1, :patient_case_id => 2 }
  # end
  it "calls authorize! on patient_case with current user id" do
    pending
    # @patient_case.should_receive(:authorize!)
    # do_action(:put, :authorize, @params)
  end
  it "sets flash" do
    pending
  end
  it "redirects to deauthorized patient_case for the trip" do
    pending
  end
end

describe PatientCasesController, "PUT deauthorize" do
  login_admin
  
  before(:each) do
    @patient_case = mock_model(PatientCase)
  end
  it "calls deauthorize! on patient_case" do
    pending
  end
  it "sets flash" do
    pending
  end
  it "redirects to authorized patient_case for the trip" do
    pending
  end
end

describe PatientCasesController, "PUT unschedule" do
  login_admin
  
  before(:each) do
    @patient_case = mock_model(PatientCase)
  end
  it "calls unschedule! on patient_case" do
    pending
  end
  it "sets flash" do
    pending
  end
  it "redirects back" do
    pending
  end
end

describe PatientCasesController, "GET review" do
  login_admin
  
  context "with trip" do
    before(:each) do
      @herp = mock_model(PatientCase)
      @derp = mock_model(PatientCase)
    end
    it "assigns new cases to an array of ids" do
      PatientCase.stub(:find).with(:trip_id => 1, :status => "New").and_return([@herp, @derp])
      # get :review, :trip_id => 1
      get :review
      assigns(:new_cases).should eq([@herp.id, @derp.id])
    end
  end
  context "no trip" do
    
  end
end
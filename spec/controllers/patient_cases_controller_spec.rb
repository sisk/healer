require 'spec_helper'

# def do_action(request_method, action, params = {})
#   do_valid_login
#   send request_method, action, params
# end

describe PatientCasesController, "PUT authorize" do
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
require 'spec_helper'

# def do_action(request_method, action, params = {})
#   do_valid_login
#   send request_method, action, params
# end

describe RegistrationsController, "PUT authorize" do
  # before(:each) do
  #   @registration = mock_model(Registration)
  #   Registration.stub(:find_by_id).with(2).and_return(@registration)
  #   @params = { :trip_id => 1, :registration_id => 2 }
  # end
  it "calls authorize! on registration with current user id" do
    pending
    # @registration.should_receive(:authorize!)
    # do_action(:put, :authorize, @params)
  end
  it "sets flash" do
    pending
  end
  it "redirects to deauthorized registrations for the trip" do
    pending
  end
end

describe RegistrationsController, "PUT deauthorize" do
  before(:each) do
    @registration = mock_model(Registration)
  end
  it "calls deauthorize! on registration" do
    pending
  end
  it "sets flash" do
    pending
  end
  it "redirects to authorized registrations for the trip" do
    pending
  end
end

describe RegistrationsController, "PUT unschedule" do
  before(:each) do
    @registration = mock_model(Registration)
  end
  it "calls unschedule! on registration" do
    pending
  end
  it "sets flash" do
    pending
  end
  it "redirects back" do
    pending
  end
end
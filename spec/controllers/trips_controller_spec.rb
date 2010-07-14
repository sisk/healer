require 'spec_helper'

def do_action(request_method, action, params = {})
  # @user = users(:aaron)
  @user = Factory.create(:user)
  # @user.save
  sign_in :user, @user
  #do_valid_login
  send request_method, action, params
end

describe TripsController, "GET#index" do
  # should_require_login :get, :index
  it "responds" do
    do_action :get, :index
    response.should be_success
  end
end

describe TripsController, "GET#new" do
  # should_require_login :get, :new
  before(:each) do
    @trip ||= mock_model(Trip)
  end
  it "responds successfully" do
    do_action :get, :new
    response.should be_success
  end
  it "creates a new trip model" do
    Trip.should_receive(:new).and_return(@trip)
    do_action :get, :new
  end
end

# describe TripsController, "GET#edit" do
#   # should_require_login :get, :edit
#   before(:each) do
#     @params = { :id => 1212121212 }
#     Trip.stub!(:find).with(@params[:id].to_s)
#   end
#   it "renders the application layout" do
#     do_action :get, :edit, @params
#     response.layout.should == "layouts/application"
#   end
# end

describe TripsController, "POST#create" do
  # should_require_login :post, :create
  before(:each) do
    @trip ||= mock_model(Trip, :save => nil)
    @params = {:trip => {}}
  end
end

describe TripsController, "PUT#update" do
  # should_require_login :put, :update
  before(:each) do
    @trip ||= mock_model(Trip, :save => nil, :update_attributes => nil)
    @params = { :id => @trip.id, :trip => {} }
    Trip.stub!(:find_by_id).with(@params[:id].to_s).and_return(@trip)
  end
end
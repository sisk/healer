require 'spec_helper'

def do_action(request_method, action, params = {})
  do_valid_login
  send request_method, action, params
end

describe UserSessionsController, "GET new" do
  before(:each) do
    @user_session ||= mock_model(UserSession)
  end
  it "responds successfully" do
    do_action :get, :new
    response.should be_success
  end
  it "renders the blank layout" do
    do_action :get, :new
    response.layout.should == "layouts/blank"
  end
  it "creates a new session model" do
    UserSession.should_receive(:new).and_return(@user_session)
    do_action :get, :new
  end
end

describe UserSessionsController, "POST create" do
  before(:each) do
    @user_session ||= mock_model(UserSession, :save => nil)
    @params = {:user_session => {}}
  end
  it "creates a new session model with supplied params" do
    UserSession.should_receive(:new).with(@params[:user_session]).and_return(@user_session)
    do_action :post, :create, @params
  end
  it "saves the session" do
    UserSession.stub(:new).and_return(@user_session)
    @user_session.should_receive(:save)
    do_action :post, :create, @params
  end
  context "when save succeeds" do
    before(:each) do
      @user_session.stub!(:save).and_return(true)
      UserSession.stub(:new).with(@params[:user_session]).and_return(@user_session)
    end
    it "sets the appropriate flash notice" do
      do_action :post, :create, @params
      flash[:notice].should == "Successfully logged in."
    end
    it "redirects to root_path" do
      do_action :post, :create, @params
      response.should redirect_to(root_path)
    end
  end
  context "when save fails" do
    before(:each) do
      @user_session.stub!(:save).and_return(false)
      UserSession.stub(:new).with(@params[:user_session]).and_return(@user_session)
    end
    it "renders the blank layout" do
      do_action :post, :create, @params
      response.layout.should == "layouts/blank"
    end
    it "renders the new template" do
      do_action :post, :create, @params
      response.should render_template("new")
    end
  end
end

describe UserSessionsController, "DELETE destroy" do
  should_require_login :delete, :destroy
  # should_require_user_role :delete, :destroy, [:derp_role]
  before(:each) do
    @user_session ||= mock_model(UserSession, :destroy => nil)
    controller.stub!(:current_user_session).and_return(@user_session)
  end
  it "sets the session" do
    do_action :delete, :destroy
    assigns[:user_session].should == @user_session
  end
  it "calls destroy on the session" do
    @user_session.should_receive(:destroy)
    do_action :delete, :destroy
  end
  it "redirects to root" do
    do_action :delete, :destroy
    response.should redirect_to(root_path)
  end
  context "on success" do
    before(:each) do
      @user_session.stub(:destroy).and_return(true)
    end
    it "sets the appropriate flash notice" do
      do_action :delete, :destroy
      flash[:notice].should == "You have been logged out."
    end
  end
  context "on failure" do
    before(:each) do
      @user_session.stub(:destroy).and_return(false)
    end
    it "sets the appropriate flash error" do
      do_action :delete, :destroy
      flash[:error].should == "Logout failed."
    end
  end
end
require 'spec_helper'

def do_action(request_method, action, params = {})
  do_valid_login
  send request_method, action, params
end

describe UsersController, "GET#index" do
  it "redirects to root" do
    do_action :get, :index
    response.should redirect_to(root_path)
  end
end

describe UsersController, "GET#new" do
  # should_require_login :get, :new
  before(:each) do
    @user ||= mock_model(User)
  end
  it "responds successfully" do
    do_action :get, :new
    response.should be_success
  end
  it "renders the blank layout" do
    do_action :get, :new
    response.layout.should == "layouts/blank"
  end
  it "creates a new user model" do
    User.should_receive(:new).and_return(@user)
    do_action :get, :new
  end
end

describe UsersController, "GET#edit" do
  should_require_login :get, :edit
  context "when record is not found" do
    before(:each) do
      @params = { :id => 1212121212 }
      User.stub!(:find_by_id).with(@params[:id].to_s).and_return(nil)
    end
    it "should set the appropriate flash message" do
      do_action :get, :edit, @params
      flash[:error].should == "User not found."
    end
    it "redirects to root" do
      do_action :get, :edit, @params
      response.should redirect_to(root_path)
    end
  end
  context "when record is found" do
    before(:each) do
      @user ||= mock_model(User)
      @params = { :id => @user.id }
      User.stub!(:find_by_id).with(@params[:id].to_s).and_return(@user)
    end
    it "finds and sets the user object" do
      do_action :get, :edit, @params
      assigns[:user].should == @user
    end
    it "renders the edit HAML" do
      do_action :get, :edit, @params
      response.should render_template("edit")
    end
    it "renders the application layout" do
      do_action :get, :edit, @params
      response.layout.should == "layouts/application"
    end
  end
end

describe UsersController, "POST#create" do
  # should_require_login :post, :create
  before(:each) do
    @user ||= mock_model(User, :save => nil)
    @params = {:user => {}}
  end
  it "creates a new user model with supplied params" do
    User.should_receive(:new).with(@params[:user]).and_return(@user)
    do_action :post, :create, @params
  end
  it "saves the user" do
    User.stub(:new).and_return(@user)
    @user.should_receive(:save)
    do_action :post, :create, @params
  end
  context "when save succeeds" do
    before(:each) do
      @user.stub!(:save).and_return(true)
      User.stub(:new).with(@params[:user]).and_return(@user)
    end
    it "sets the appropriate flash notice" do
      do_action :post, :create, @params
      flash[:notice].should == "Registration successful."
    end
    it "redirects to root_path" do
      do_action :post, :create, @params
      response.should redirect_to(root_path)
    end
  end
  context "when save fails" do
    before(:each) do
      @user.stub!(:save).and_return(false)
      User.stub(:new).with(@params[:user]).and_return(@user)
    end
    it "sets the appropriate flash error" do
      do_action :post, :create, @params
      flash[:error].should == "Registration failed."
    end
    it "renders the new template" do
      do_action :post, :create, @params
      response.should render_template("new")
    end
  end
end

describe UsersController, "PUT#update" do
  should_require_login :put, :update
  before(:each) do
    @user ||= mock_model(User, :save => nil, :update_attributes => nil)
    @params = { :id => @user.id, :user => {} }
    User.stub!(:find_by_id).with(@params[:id].to_s).and_return(@user)
  end
  it "finds and sets the user object" do
    do_action :put, :update, @params
    assigns[:user].should == @user
  end
  it "updates the user attributes" do
    @user.should_receive(:update_attributes).with(@params[:user])
    do_action :put, :update, @params
  end
  context "when update succeeds" do
    before(:each) do
      @user.stub!(:update_attributes).and_return(true)
    end
    it "sets the appropriate flash notice" do
      do_action :put, :update, @params
      flash[:notice].should == "Profile updated."
    end
    it "redirects to edit form" do
      do_action :put, :update, @params
      response.should redirect_to(edit_user_path(@user))
    end
  end
  context "when update fails" do
    before(:each) do
      @user.stub!(:update_attributes).and_return(false)
    end
    it "sets the appropriate flash error" do
      do_action :put, :update, @params
      flash[:error].should == "Profile save failed."
    end
    it "renders the edit template" do
      do_action :put, :update, @params
      response.should render_template("edit")
    end
  end
end

module ControllerMacros
  
  def should_require_login(request_method, action)
    describe "for anonymous user" do
      before(:each) do
        controller.stub!(:current_user).and_return(nil)
        controller.stub!(:current_user_session).and_return(nil)
      end
      it "should redirect to the login page" do
        send request_method, action
        response.should redirect_to(login_path)
      end
      it "should not call the ##{action} action" do
        controller.should_not_receive(action)
        send request_method, action
      end
      it "should set a proper flash notice" do
        send request_method, action
        flash[:notice].should == "Login required."
      end
    end
  end
  # TODO Maybe? So far, there's no compelling reason to test for this. See Authlogic persistence methods in ApplicationController.
  # def should_require_no_login(request_method, action)
  #   describe "for anonymous user" do
  #     it "should call the ##{action} action" do
  #       send request_method, action
  #       response.should be_success
  #     end
  #     it "should set a proper flash notice" do
  #       send request_method, action
  #       flash[:notice].should == "You must be logged out to access this function."
  #     end
  #   end
  # end
  
  def should_require_user_role(request_method, action, roles = [])
    describe "for users not in #{roles.join(", ")} role" do
      before(:each) do
        # stub_login_impediments
        @bad_user = mock_model(User)
        @bad_user.stub!(:any_role?).with(roles).and_return(false)
        controller.stub!(:current_user).and_return(@bad_user)
      end
      it "should set the appropriate flash error" do
        send request_method, action
        flash[:error].should == "You do not have permission to peform that function."
      end
      # it "should redirect to the dashboard" do
      #   send request_method, action
      #   response.should redirect_to(dashboard_path)
      # end
      it "should not call the ##{action} action" do
        controller.should_not_receive(action)
        send request_method, action
      end
    end
  end

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in create(:user_admin)
    end
  end

  def login_doctor
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in create(:user_doctor)
    end
  end

end
def do_valid_login
  # stub_login_impediments
  # @current_user = mock_model(User)
  # @current_user.stub!(:has_role?).and_return(true)
  # controller.stub!(:current_user).and_return(@current_user)
  # Authorization.stub!(:current_user).and_return(@current_user)
  # session[:user_id] = @current_user.id
  # puts "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  # puts @current_user.inspect
end

def stub_login_impediments
  # required to stub out timeout for Defv::SessionLifetime::InstanceMethods in dynamic_session_expiry
  # controller.stub!(:session_expire).and_return({:time => 3.hours, :token_auth => nil})

  # stub out other junk we need to bypass
end

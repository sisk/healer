class UserSessionsController < ApplicationController

  layout "blank"

  before_filter :require_user, :only => [:destroy]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to root_path
    else
      render :action => "new"
    end
  end

  def destroy
    @user_session = current_user_session
    if @user_session.destroy
      flash[:notice] = "You have been logged out."
    else
      flash[:error] = "Logout failed."
    end
    redirect_to root_path
  end

end

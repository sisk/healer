class SessionsController < ApplicationController
  include Devise::Controllers::Helpers

  def easy
    @users = easy_users
    render :layout => "session"
  end

  def create_easy
    sign_in(User.find(params[:user_id]))
    redirect_to splash_page
  end

  private

  def easy_users
    Trip.current.first.users.sort_by(&:to_s)
  end

end
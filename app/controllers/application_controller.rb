class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  protect_from_forgery
  layout :layout_by_resource

  def layout_by_resource
    devise_controller? ? "session" : "application"
  end

  # tell declarative_authorization who our current user is for all requests
  before_filter { |c| Authorization.current_user = c.current_user }

  # TODO implement the Rails 3 version of this.
  # filter_parameter_logging :password

  protected

  def permission_denied
    flash[:error] = "Sorry, you are not allowed to access that page."
    redirect_to root_url
  end

end

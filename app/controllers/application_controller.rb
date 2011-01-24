class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  before_filter :set_locale
  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    if user_signed_in?
      I18n.locale = params[:locale] || current_user.language
    end
  end
  # def default_url_options(options={})
  #   { :locale => I18n.locale }
  # end
    
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
    flash[:error] = t(:page_access_denied)
    # "Sorry, you are not allowed to access that page."
    redirect_to root_url
  end

end

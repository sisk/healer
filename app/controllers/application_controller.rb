require "config"

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  def after_sign_in_path_for(resource)
    splash_page
  end

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

  def authenticate_user!
    if allow_easy_login? && !signed_in?
      redirect_to easy_session_path
    else
      super
    end
  end

  def layout_by_resource
    devise_controller? ? "session" : "application"
  end

  # tell declarative_authorization who our current user is for all requests
  before_filter { |c| Authorization.current_user = c.current_user }

  # TODO implement the Rails 3 version of this.
  # filter_parameter_logging :password

  def request_ipad?
    request.user_agent.match(/iPad/)
  end

  def request_iphone?
    request.user_agent.match(/iPhone/)
  end

  protected

  def splash_page
    current_trips_path
  end

  def mobile_agent?
    request.user_agent.match(/iPad/) ||
    request.user_agent.match(/iPhone/)
  end

  def permission_denied
    flash[:error] = t(:page_access_denied)
    # "Sorry, you are not allowed to access that page."
    redirect_to root_url
  end

  def allow_easy_login?
    in_field? && Trip.current.present?
  end

  def in_field?
    # TODO js: this is pretty crude. need something better.
    !env["HTTP_HOST"].include?("healer.ws")
  end

  def easy_users
    Trip.next.first.users
    # Trip.current.first.users
  end

end

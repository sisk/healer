class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  protect_from_forgery
  layout 'application'

  # TODO implement the Rails 3 version of this.
  # filter_parameter_logging :password

private

end

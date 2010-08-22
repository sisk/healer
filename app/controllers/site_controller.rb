class SiteController < ApplicationController
  before_filter :authenticate_user!
  def index
    
  end
  
  def test_email
    Mailer.test(User.first).deliver
  end
end

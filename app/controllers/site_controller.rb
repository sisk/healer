class SiteController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def test_error
    raise "This should throw an error"
  end

end

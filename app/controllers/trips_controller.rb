class TripsController < InheritedResources::Base
# class TripsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    create! { trips_path }
  end
  def update
    update! { trips_path }
  end

end

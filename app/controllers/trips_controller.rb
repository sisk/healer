class TripsController < InheritedResources::Base
  before_filter :require_user
  
  def create
    create! { trips_path }
  end
end

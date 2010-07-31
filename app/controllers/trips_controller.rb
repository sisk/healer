class TripsController < InheritedResources::Base
# class TripsController < ApplicationController
  before_filter :authenticate_user!
  # FIXME turn back on when auth engine is fixed
  # filter_resource_access
  
  def index
    @future_trips = end_of_association_chain.future
    @past_trips = end_of_association_chain.past
    @current_trips = end_of_association_chain.current
  end

  def create
    create! { trips_path }
  end
  def update
    update! { trips_path }
  end

end

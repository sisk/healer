class TripsController < InheritedResources::Base
  before_filter :authenticate_user!
  filter_resource_access
  
  def index
    @future_trips = end_of_association_chain.future
    @past_trips = end_of_association_chain.past
    @current_trips = end_of_association_chain.current
  end
  
  def show
    @authorized_registrations = @trip.registrations.authorized
  end

  def create
    create! { trips_path }
  end
  def update
    update! { trips_path }
  end

end

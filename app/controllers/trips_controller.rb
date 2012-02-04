class TripsController < ApplicationController
  inherit_resources

  before_filter :authenticate_user!
  filter_resource_access

  def index
    if params[:jump_to]
      trip = Trip.find(params[:jump_to])
      redirect_to trip_path(trip) if trip
    end
    @future_trips = end_of_association_chain.future
    @past_trips = end_of_association_chain.past
    @current_trips = end_of_association_chain.current
  end

  def show
    @authorized_patient_cases = @trip.patient_cases.authorized
  end

  def create
    create! { trips_path }
  end

  def update
    update! { trips_path }
  end

end

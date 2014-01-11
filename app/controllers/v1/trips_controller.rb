require "v1/trip_decorator"

class V1::TripsController < V1::BaseController

  def index
    @trips = V1::TripDecorator.decorate_collection(Trip.all)
  end

  def show
    @trip = Trip.find_by_nickname(params[:nickname])
  end

end
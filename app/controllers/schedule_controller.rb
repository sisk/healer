class ScheduleController < ApplicationController
  before_filter :authenticate_user!, :setup_trip

  def edit
    @unregistered = @trip.registrations.unscheduled
    @rooms = @trip.try(:facility).try(:rooms) || []
  end
  
  def show
    @registrations = @trip.registrations
  end

private

  def setup_trip
    @trip ||= Trip.find(params[:trip_id])
  end

end

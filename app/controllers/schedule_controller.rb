class ScheduleController < ApplicationController
  before_filter :authenticate_user!, :setup_trip

  def edit
    @unregistered = @trip.registrations.unscheduled
  end

private

  def setup_trip
    @trip ||= Trip.find(params[:trip_id])
  end

end

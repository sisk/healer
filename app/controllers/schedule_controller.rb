class ScheduleController < ApplicationController
  before_filter :authenticate_user!, :setup_trip

  def edit
    @unscheduled = @trip.registrations.authorized.unscheduled
    @rooms = @trip.try(:facility).try(:rooms) || []
  end
  
  def show
    @registrations = @trip.registrations.authorized
  end
  
  def sort_room
    if !params[:room_id].present?
      flash[:error] = "You must specify a room."
      return
    end
    registration_ids = params[:registration.to_s]

    Registration.update_all("room_id = '#{params[:room_id]}'", :id => registration_ids)
    Registration.order(registration_ids)

    room_registrations = @trip.registrations.room(params[:room_id].to_s)
    @trip.reload

    respond_to do |format|
      format.json {
        registrations_json = @trip.registrations.authorized.room(params[:room_id].to_s).to_json
        render :text => "{\"registrations\" : #{registrations_json}}"
      }
    end
  end

  def sort_unscheduled
    # registration_ids passed here should become "unscheduled"
    registration_ids = params[:registration.to_s]
    Registration.update_all({:status => 'Unscheduled', :room_id => nil}, :id => registration_ids)
    Registration.order(registration_ids)

    registrations = Registration.find(registration_ids)

    respond_to do |format|
      format.json {
        render :text => "{\"registrations\" : #{registrations.to_json}}"
      }
    end
  end

private

  def setup_trip
    @trip ||= Trip.find(params[:trip_id])
  end

end

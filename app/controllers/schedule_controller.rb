class ScheduleController < ApplicationController
  before_filter :authenticate_user!, :setup_trip

  def edit
    @to_schedule = (@trip.registrations.authorized.unscheduled + @trip.registrations.authorized.no_day).uniq
    @rooms = @trip.try(:facility).try(:rooms) || []
    @number_of_days = @trip.number_of_operation_days || 0
  end
  
  def show
    @registrations = @trip.registrations.authorized
  end
  
  def sort_room
    if !params[:room_id].present?
      flash[:error] = "You must specify a room."
      return
    end
    if !params[:day].present?
      flash[:error] = "You must specify a day."
      return
    end
    registration_ids = params[:registration.to_s]

    Registration.update_all("room_id = #{params[:room_id].to_i}, scheduled_day = #{params[:day].to_i}", :id => registration_ids )
    Registration.order(registration_ids)

    @trip.reload

    respond_to do |format|
      format.json {
        registrations_json = @trip.registrations.authorized.room(params[:room_id].to_s).day(params[:day].to_s).to_json
        render :text => "{\"registrations\" : #{registrations_json}}"
      }
    end
  end

  def sort_unscheduled
    # registration_ids passed here should become "unscheduled"
    registration_ids = params[:registration.to_s]
    Registration.update_all({:status => 'Unscheduled', :room_id => nil, :scheduled_day => 0}, :id => registration_ids)
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

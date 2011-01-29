class ScheduleController < ApplicationController
  before_filter :authenticate_user!, :setup_trip

  def edit
    @to_schedule = @trip.registrations.authorized.unscheduled
    @rooms = @trip.try(:facility).try(:rooms) || []
    @number_of_days = @trip.number_of_operation_days || 0
  end
  
  def show
    @number_of_days = @trip.number_of_operation_days || 0
    if params[:room].present?
      @room = Room.find(params[:room])
      render :template => "schedule/show_room"
    elsif params[:day].present?
      @day = params[:day]
      @rooms = @trip.try(:facility).try(:rooms) || []
      render :template => "schedule/show_day"
    else
      @registrations = @trip.registrations.authorized
      @rooms = @trip.try(:facility).try(:rooms) || []
    end
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
    @room_id = params[:room_id].to_i
    @day_num = params[:day].to_i
    if params[:registration].present?
      registration_ids = params[:registration.to_s]
      Registration.update_all("room_id = #{@room_id}, scheduled_day = #{@day_num}", :id => registration_ids )
      params[:registration].each_with_index do |id, index|
        Registration.update_all(['schedule_order = ?', index + 1], ['id = ?', id])
      end
      @registrations = Registration.find(registration_ids)
    end

    respond_to do |format|
      format.js { render :template => "schedule/sort_room.js.erb", :layout => nil }
    end
  end

  def sort_unscheduled
    # registration_ids passed here should become "unscheduled"
    if params[:registration].present?
      registration_ids = params[:registration.to_s]
      Registration.update_all({:status => 'Unscheduled', :room_id => nil, :scheduled_day => 0}, :id => registration_ids)
      params[:registration].each_with_index do |id, index|
        Registration.update_all(['schedule_order = ?', index + 1], ['id = ?', id])
      end

      @registrations = Registration.find(registration_ids)
    end

    respond_to do |format|
      format.js { render :template => "schedule/sort_unscheduled.js.erb", :layout => nil }
    end
  end

private

  def setup_trip
    @trip ||= Trip.find(params[:trip_id])
  end

end

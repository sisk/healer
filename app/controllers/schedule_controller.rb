class ScheduleController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @to_schedule = trip.case_groups.unscheduled
    @number_of_rooms = trip.available_rooms || 0
    @number_of_days = trip.number_of_operation_days || 0
  end

  def show
    @number_of_days = trip.number_of_operation_days || 0
    @number_of_rooms = trip.available_rooms || 0
    if params[:room_number].present?
      @room_number = params[:room_number]
      render :template => "schedule/show_room"
    elsif params[:day].present?
      @day = params[:day]
      render :template => "schedule/show_day"
    else
      @case_groups = trip.case_groups
    end
  end

  def sort_room
    if !params[:room_number].present?
      flash[:error] = "You must specify a room."
      return
    end
    if !params[:day].present?
      flash[:error] = "You must specify a day."
      return
    end
    @room_number = params[:room_number].to_i
    @day_num = params[:day].to_i
    if params[:case_group].present?
      case_group_ids = params[:case_group.to_s]
      CaseGroup.update_all("room_number = #{@room_number}, scheduled_day = #{@day_num}", :id => case_group_ids )
      params[:case_group].each_with_index do |id, index|
        CaseGroup.update_all(['schedule_order = ?', index + 1], ['id = ?', id])
      end
      @case_groups = CaseGroup.find(case_group_ids)
    end

    respond_to do |format|
      format.js { render :template => "schedule/sort_room.js.erb", :layout => nil }
    end
  end

  def sort_unscheduled
    # case_group_ids passed here should become "unscheduled"
    if params[:case_group].present?
      case_group_ids = params[:case_group.to_s]
      CaseGroup.update_all({:room_number => nil, :scheduled_day => 0}, :id => case_group_ids)
      params[:case_group].each_with_index do |id, index|
        CaseGroup.update_all(['schedule_order = ?', index + 1], ['id = ?', id])
      end

      @case_groups = CaseGroup.find(case_group_ids)
    end

    respond_to do |format|
      format.js { render :template => "schedule/sort_unscheduled.js.erb", :layout => nil }
    end
  end

private

  def trip
    @trip ||= Trip.find(params[:trip_id])
  end

end

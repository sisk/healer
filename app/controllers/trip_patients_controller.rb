class TripPatientsController < ApplicationController
  require 'will_paginate/array'

  inherit_resources
  defaults :resource_class => Patient, :collection_name => 'patients', :instance_name => 'patient'

  belongs_to :trip
  before_filter :authenticate_user!

  def index
    @anatomies = parent.patient_cases.map(&:anatomy).uniq.compact

    @all_patients = collection
    @paginated_patients = collection.paginate( :page => params[:page], :per_page => 10 )
    index! do |format|
      format.html
      format.js { render :template => "trip_patients/index.js.erb", :layout => nil }
    end
  end

  def room_signs
    @trip = Trip.find(params[:trip_id])
    @all_cases = @trip.appointments.scheduled.sort_by{ |cg| cg.patient.id }
    if params[:patient_ids]
      @all_cases = @all_cases.select{ |c| params[:patient_ids].map(&:to_i).include?(c.patient.id) }
    end
    render :layout => "sign"
  end

  private ######################################################################

  def begin_of_association_chain
    @trip
  end

  def collection
    if params[:authorized_status] || params[:anatomies] || params[:search]
      if params[:search]
        begin
          patient_id = Integer(params[:search])
          subset = end_of_association_chain.find_all_by_id(patient_id, :include => :patient_cases)
        rescue ArgumentError
          subset = end_of_association_chain.search(params[:search])
        end
      else
        subset = end_of_association_chain
      end

      case params[:authorized_status]
      when "authorized"
        subset = subset.authorized
      when "unauthorized"
        subset = subset.unauthorized
      end
      if params[:anatomies]
        subset = subset.anatomy(Array(params[:anatomies])).ordered_by_id
      end

    else
      subset ||= end_of_association_chain.ordered_by_id
    end
    @trip_patients ||= subset
  end

end

class PatientCasesController < ApplicationController

  inherit_resources
  defaults :resource_class => PatientCase, :collection_name => 'patient_cases', :instance_name => 'patient_case'
  custom_actions :resource => :review, :collection => [:waiting, :bulk]
  actions :all

  before_filter :authenticate_user!
  before_filter :set_unregistered_patients, :only => [:new, :create]
  filter_resource_access :collection => [:index, :review, :waiting, :bulk]

  belongs_to :trip, :optional => true
  belongs_to :patient, :optional => true

  def bulk
    @patient_cases = PatientCase.find(params[:bulk_cases])
    @patient = @patient_cases.first.patient
    @trip = @patient_cases.first.trip
    @old_appointments = @patient_cases.map(&:appointment_id).uniq

    case params[:bulk_action]
    when "group"

      PatientCase.group_cases(@patient_cases)

      # Reload all cases for re-drawing
      @patient_cases.each{ |pc| pc.reload }
      @new_appointments = @patient_cases.map(&:appointment).uniq.compact
      authorized_cases = @patient_cases.select{ |pc| pc.authorized? }
      unauthorized_cases = @patient_cases.select{ |pc| !pc.authorized? }

      respond_to do |format|
        format.html {
          redirect_to :back, :notice => "Grouped cases."
        }
        format.js {
          render :template => "patient_cases/refresh_cases.js.erb", :layout => nil
        }
      end
    when "ungroup"
      (@patient_cases - [@patient_cases.first]).each do |revised_patient_case|
        # clear all case groups from everythign but the first patient case submitted for bulk.
        # the model should handle recreating new case groups on save.
        revised_patient_case.update_attributes(:appointment => nil)
      end
      @patient_cases.each{ |pc| pc.reload }
      @new_appointments = @patient_cases.map(&:appointment).uniq.compact
      respond_to do |format|
        format.html {
          redirect_to :back, :notice => "Grouped cases."
        }
        format.js {
          render :template => "patient_cases/refresh_cases.js.erb", :layout => nil
        }
      end


    when "unapprove"
      @patient_cases.each{ |pc| pc.deauthorize! }
      respond_to do |format|
        format.html {
          redirect_to :back, :notice => "Deauthorized cases."
        }
        format.js {
          render :template => "patient_cases/refresh_cases.js.erb", :layout => nil
        }
      end
    else
      render :nothing => true
    end
  end

  def new
    new! do
      if params[:patient_id]
        @patient = Patient.find(params[:patient_id])
      end
    end
  end

  # def new
  #   new!{
  #     if @trip
  #       render :action => "trips_new"
  #       return
  #     elsif @patient
  #       render :action => "patients_new"
  #       return
  #     else
  #     end
  #   }
  # end

  def create
    create! do |success, failure|
      success.html {
        if @trip
          redirect = trip_patients_path(@patient_case.trip, :patient_id => @patient_case.patient_id)
        elsif @patient
          redirect = patient_path(@patient_case.patient)
        end
        redirect_to redirect, :notice => "Created case for patient ##{@patient_case.patient_id}."
        return
      }
      failure.html {
        flash[:error] = resource.errors.full_messages.to_sentence
        if @trip
          render_action = :new
        elsif @patient
          render_action = "patients_new"
        end
        render render_action, :error => "Error adding case."
        return
      }
    end
  end

  def update
    @patient_case = PatientCase.find(params["id"])

    if @patient_case.update_attributes(params["patient_case"])
      flash[:notice] = "Case updated."
    end
    respond_with(@patient_case) do |format|
      format.html do
        if params[:return_to] == "schedule"
          redirect_to trip_schedule_path(@patient_case.trip, :day => params[:day])
        else
          redirect_to trip_case_path(@patient_case.trip, @patient_case)
        end
      end
      format.js { render :template => "patient_cases/update.js.erb", :layout => nil }
    end
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to parent_path, :notice => "Case deleted." }
    end
  end

  def review
    if params[:trip_id].present?
      @new_cases = PatientCase.find(:all, :conditions => ["trip_id = ? and status = ?", params[:trip_id], "New"]).map(&:id)
      @deferred_cases = PatientCase.find(:all, :conditions => ["trip_id = ? and status = ?", params[:trip_id], "Deferred"]).map(&:id)
      @scheduled_cases = PatientCase.find(:all, :conditions => ["trip_id = ? and status = ?", params[:trip_id], "Scheduled"]).map(&:id)
    else

    end
  end

  def authorize
    @patient_case.authorize!(current_user.id)
    respond_with(@patient_case) do |format|
      format.html {
        flash[:notice] = "Approved case for #{@patient_case.patient}."
        redirect_to :back
      }
      format.js { render :template => "patient_cases/authorize.js.erb", :layout => nil }
    end
  end

  def deauthorize
    @patient_case.deauthorize!
    flash[:notice] = "Moved case for #{@patient_case.patient} to waiting."
    redirect_to :back
  end

  def unschedule
    if @patient_case.unschedule!
      redirect_to :back, :notice => "Moved case to waiting."
    else
      redirect_to :back, :error => "Could not unschedule case."
    end
  end

  def certificate
    @patient_case = PatientCase.find(params["id"])
    render :layout => "patient_certificate"
  end

private

  def build_resource
    super
    @patient_case.build_patient(params[:patient]) unless @patient_case.patient.present?
    @patient_case
  end

  def set_unregistered_patients
    if params[:trip_id].present?
      trip = Trip.find(params[:trip_id])
      @all_patients = Patient.country(trip.country)
    else
      @all_patients = Patient.all
    end
  end

protected

  def collection
    end_of_association_chain.authorized
  end

  def authorized_patient_cases_count
    @authorized_patient_cases_count ||= end_of_association_chain.authorized.count
  end

  def unauthorized_patient_cases_count
    @unauthorized_patient_cases_count ||= end_of_association_chain.unauthorized.count
  end

end

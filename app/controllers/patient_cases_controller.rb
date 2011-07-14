class PatientCasesController < ApplicationController

  inherit_resources
  defaults :resource_class => PatientCase, :collection_name => 'patient_cases', :instance_name => 'patient_case'
  actions :all

  before_filter :authenticate_user!
  before_filter :set_unregistered_patients, :only => :new
  filter_resource_access :collection => [:index, :review]

  belongs_to :trip, :optional => true

  def index
    @authorized_patient_cases = authorized_patient_cases
    @unauthorized_patient_cases = unauthorized_patient_cases
    index! do |format|
      format.json {
        render :text => "{\"patient_cases\" : #{@authorized_patient_cases.to_json}}"
      }
    end
  end

  def create
    @trip = Trip.find(params[:trip_id])
    create! { trip_case_path(@patient_case.trip, @patient_case) }
  end

  def update
    @patient_case = PatientCase.find(params["id"])

    if @patient_case.update_attributes(params["patient_case"])
      flash[:notice] = "Case updated."
    end
    respond_with(@patient_case) do |format|
      format.html { redirect_to trip_cases_path(@patient_case.trip) }
      format.js { render :template => "patient_cases/update.js.erb", :layout => nil }
    end
  end

  def destroy
    destroy! do |format|
      format.html { redirect_to parent_path, :notice => "Case deleted." }
    end
  end

  # non-CRUD
  def review
    if params[:trip_id].present?
      # raise params[:trip_id].inspect
      @new_cases = PatientCase.find(:all, :conditions => ["trip_id = ? and status = ?", params[:trip_id], "New"]).map(&:id)
      @deferred_cases = PatientCase.find(:all, :conditions => ["trip_id = ? and status = ?", params[:trip_id], "Deferred"]).map(&:id)
      @scheduled_cases = PatientCase.find(:all, :conditions => ["trip_id = ? and status = ?", params[:trip_id], "Scheduled"]).map(&:id)
    else

    end
  end

  def authorize
    @patient_case.authorize!(current_user.id)
    flash[:notice] = "Approved case for #{@patient_case.patient}."
    redirect_to trip_cases_path(@patient_case.trip, :anchor => "waiting")
  end

  def deauthorize
    @patient_case.deauthorize!
    flash[:notice] = "Moved case for #{@patient_case.patient} to waiting."
    redirect_to trip_cases_path(@patient_case.trip, :anchor => "approved")
  end

  def unschedule
    if @patient_case.unschedule!
      redirect_to :back, :notice => "Moved case to waiting."
    else
      redirect_to :back, :error => "Could not unschedule case."
    end
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

  def authorized_patient_cases
    if params[:search].present?
      @authorized_patient_cases ||= end_of_association_chain.authorized.search(params[:search])
    else
      @authorized_patient_cases ||= end_of_association_chain.authorized
    end
  end
  def unauthorized_patient_cases
    if params[:search].present?
      @unauthorized_patient_cases = end_of_association_chain.unauthorized.search(params[:search])
    else
      @unauthorized_patient_cases = end_of_association_chain.unauthorized
    end
  end

end

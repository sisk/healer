class RegistrationsController < ApplicationController
  inherit_resources
  
  before_filter :authenticate_user!
  before_filter :set_unregistered_patients, :only => :new
  filter_resource_access

  belongs_to :trip, :optional => true

  def index
    @authorized_registrations = authorized_registrations
    @unauthorized_registrations = unauthorized_registrations
    index! do |format|
      format.json {
        render :text => "{\"registrations\" : #{@authorized_registrations.to_json}}"
      }
    end
  end

  def create
    create! { trip_registrations_path(@registration.trip_id) }
  end
  def update
    @registration = Registration.find(params["id"])

    if @registration.update_attributes(params["registration"])
      flash[:notice] = "Registration updated."
    end
    respond_with(@registration) do |format|
      format.html { redirect_to trip_registrations_path(@registration.trip) }
      format.js { render :template => "registrations/update.js.erb", :layout => nil }
    end
  end
  def destroy
    destroy! {
      @trip.present? ? trip_registrations_path(@trip) : registrations_path
    }
  end

  # non-REST
  def authorize
    @registration.authorize!(current_user.id)
    flash[:notice] = "Approved registration for #{@registration.patient}."
    redirect_to trip_registrations_path(@registration.trip, :anchor => "waiting")
  end
  def deauthorize
    @registration.deauthorize!
    flash[:notice] = "Moved registration for #{@registration.patient} to waiting."
    redirect_to trip_registrations_path(@registration.trip, :anchor => "approved")
  end

private

  def build_resource
    super
    @registration.build_patient(params[:patient]) unless @registration.patient.present?
    @registration
  end

  def set_unregistered_patients
    @all_patients = Patient.all
  end

protected

  def authorized_registrations
    if params[:search].present?
      @authorized_registrations ||= end_of_association_chain.authorized.search(params[:search])
    else
      @authorized_registrations ||= end_of_association_chain.authorized
    end
  end
  def unauthorized_registrations
    if params[:search].present?
      @unauthorized_registrations = end_of_association_chain.unauthorized.search(params[:search])
    else
      @unauthorized_registrations = end_of_association_chain.unauthorized
    end
  end

end

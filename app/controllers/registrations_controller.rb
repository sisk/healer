class RegistrationsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :set_unregistered_patients, :only => :new
  filter_resource_access

  belongs_to :trip, :optional => true

  def index
    @authorized_registrations = end_of_association_chain.authorized
    @unauthorized_registrations = end_of_association_chain.unauthorized
  end

  def create
    create! { trip_registrations_path(@registration.trip_id) }
  end
  def update
    update! { trip_registrations_path(@registration.trip) }
  end

  # non-REST
  def authorize
    @registration.authorize!(current_user.id)
    flash[:notice] = "Authorized registration for #{@registration.patient}."
    redirect_to trip_registrations_path(@registration.trip, :anchor => "unauthorized")
  end
  def deauthorize
    @registration.deauthorize!
    flash[:notice] = "Deauthorized registration for #{@registration.patient}."
    redirect_to trip_registrations_path(@registration.trip, :anchor => "authorized")
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
  
end

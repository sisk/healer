class RegistrationsController < InheritedResources::Base
  before_filter :authenticate_user!
  filter_resource_access

  belongs_to :trip

  def index
    @authorized_registrations = end_of_association_chain.authorized
    @unauthorized_registrations = end_of_association_chain.unauthorized
  end

  # def new
  #   @trip = Trip.find(params[:trip_id])
  #   @registration = Registration.new(:trip => @trip)
  #   @registration.build_patient
  #   logger.debug @registration.patient.inspect
  # end

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
  
end

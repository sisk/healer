class RegistrationsController < InheritedResources::Base
  before_filter :authenticate_user!
  filter_resource_access

  belongs_to :trip

  # def new
  #   @trip = Trip.find(params[:trip_id])
  #   @registration = Registration.new(:trip => @trip)
  #   @registration.build_patient
  #   logger.debug @registration.patient.inspect
  # end

  # non-REST
  def authorize
  end
  def deauthorize
  end
  
private

  def build_resource
    super
    @registration.build_patient(params[:patient]) unless @registration.patient.present?
    @registration
  end
  
end

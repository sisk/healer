class PatientsController < ApplicationController
  inherit_resources
  
  before_filter :authenticate_user!
  filter_resource_access
  
  def create
    create! { patients_path }
  end

  def update
    update! { resource_path }
  end

private
  # def build_resource
  #   super
  #   @patient.risk_factors = [] unless @patient.risk_factors.present?
  #   @patient
  # end

protected

  def collection
    start = end_of_association_chain
    if params[:no_patient_cases]
      start = start.no_patient_cases
    end
    if params[:search].present?
      start = start.search(params[:search])
    end
    @patients ||= start.paginate(:page => params[:page], :per_page => 5)
  end
  
end

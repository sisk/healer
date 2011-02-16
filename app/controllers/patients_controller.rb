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
    if params[:search].present?
      @patients ||= end_of_association_chain.search(params[:search]).paginate(:page => params[:page], :per_page => 5)
    else
      @patients ||= end_of_association_chain.paginate(:page => params[:page], :per_page => 5)
    end
  end
  
end
